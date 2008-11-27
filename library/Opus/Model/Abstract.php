<?php
/**
 * This file is part of OPUS. The software OPUS has been originally developed
 * at the University of Stuttgart with funding from the German Research Net,
 * the Federal Department of Higher Education and Research and the Ministry
 * of Science, Research and the Arts of the State of Baden-Wuerttemberg.
 *
 * OPUS 4 is a complete rewrite of the original OPUS software and was developed
 * by the Stuttgart University Library, the Library Service Center
 * Baden-Wuerttemberg, the Cooperative Library Network Berlin-Brandenburg,
 * the Saarland University and State Library, the Saxon State Library -
 * Dresden State and University Library, the Bielefeld University Library and
 * the University Library of Hamburg University of Technology with funding from
 * the German Research Foundation and the European Regional Development Fund.
 *
 * LICENCE
 * OPUS is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the Licence, or any later version.
 * OPUS is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details. You should have received a copy of the GNU General Public License
 * along with OPUS; if not, write to the Free Software Foundation, Inc., 51
 * Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * @category    Framework
 * @package     Opus_Model
 * @author      Felix Ostrowski (ostrowski@hbz-nrw.de)
 * @author      Ralf Claußnitzer (ralf.claussnitzer@slub-dresden.de)
 * @copyright   Copyright (c) 2008, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 * @version     $Id$
 */

/**
 * Abstract class for all domain models in the Opus framework
 *
 * @category    Framework
 * @package     Opus_Model
 */

abstract class Opus_Model_Abstract implements Opus_Model_Interface
{
    /**
     * Holds the primary database table row. The concrete class is responsible
     * for any additional table rows it might need.
     *
     * @var Zend_Db_Table_Row
     */
    protected $_primaryTableRow;

    /**
     * Holds all fields of the domain model.
     *
     * @var array
     */
    protected $_fields = array();

    /**
     * Holds the name of those fields of the domain model that do not map to the
     * primary table row. Concrete classes that use external fields must supply
     * _fetch{fieldname} and _store{fieldname} functions that handle these fields.
     *
     * @var array
     */
    protected $_externalFields = array();

    /**
     * Constructor. Pass an id to fetch from database.
     *
     * @param int $id   Optional id of existing database row.
     * @param Zend_Db_Table $tableGatewayModel  Opus_Db model to fetch table row from.
     * @throws Opus_Model_Exception Thrown if passed id is invalid.
     * @return void
     */
    public function __construct($id = null, $tableGatewayModel = null)
    {
        if ($tableGatewayModel === null) {
            throw new Opus_Model_Exception("No table gateway model passed.");
        }
        if ($id === null) {
            $this->_primaryTableRow = $tableGatewayModel->createRow();
        } else {
            $this->_primaryTableRow = $tableGatewayModel->find($id)->getRow(0);
            if ($this->_primaryTableRow === null) {
                throw new Opus_Model_Exception("No ".
                get_class($tableGatewayModel) ." with id $id in database.");
            }
        }
        $this->_init();
        $this->_addValidators();
        $this->_fetchValues();
    }

    /**
     * Overwrite to initialize fields.
     *
     * @return void
     */
    protected function _init()
    {
    }


    /**
     * Fetch attribute values from the table row and set up all fields.
     *
     * @return void
     */
    protected function _fetchValues() {
        foreach ($this->_fields as $fieldname => $field) {
            if (in_array($fieldname, $this->_externalFields) === true) {
                $callname = '_fetch' . $fieldname;
                $this->_fields[$fieldname]->setValue($this->$callname());
            } else {
                $colname = strtolower(preg_replace('/(?!^)[[:upper:]]/','_\0', $fieldname));
                $this->_fields[$fieldname]->setValue($this->_primaryTableRow->$colname);
            }

        }
    }

    /**
     * Add validators to the fields. Opus_Validate_{fieldname} classes are
     * expected to exist.
     *
     * @return void
     */
    protected function _addValidators() {
        foreach ($this->_fields as $fieldname => $field) {
            $classname = 'Opus_Validate_' . $fieldname;
            // suppress warnings about not existing classes
            if (@class_exists($classname)) {
                $field->setValidator(new $classname);
            }
        }
    }


    /**
     * Persist all the models information to its database locations.
     *
     * @see Opus_Model_Interface::store()
     * @throws Opus_Model_Exception Thrown if the store operation could not be performed.
     * @return mixed $id    Primary key of the models primary table row.
     */
    public function store() {
        $dbadapter = $this->_primaryTableRow->getTable()->getAdapter();
        $dbadapter->beginTransaction();
        try {
            foreach ($this->_fields as $fieldname => $field) {
                if (in_array($fieldname, $this->_externalFields) === false) {
                    $colname = strtolower(preg_replace('/(?!^)[[:upper:]]/','_\0', $fieldname));
                    $this->_primaryTableRow->$colname = $this->_fields[$fieldname]->getValue();
                }
            }
            $id = $this->_primaryTableRow->save();
            foreach ($this->_externalFields as $fieldname) {
                $callname = '_store' . $fieldname;
                $this->$callname($this->_fields[$fieldname]->getValue());
            }
            $dbadapter->commit();
        } catch (Exception $e) {
            $dbadapter->rollback();
            throw new Opus_Model_Exception($e->getMessage());
        }
        return $id;
    }



    /**
     * Magic method to access the models fields via virtual set/get methods.
     *
     * @param string $name      Name of the method beeing called.
     * @param array  $arguments Arguments for function call.
     * @return mixed Might return a value if a getter method is called.
     * @throws Opus_Model_Exception If an unknown field or method is requested.
     */
    public function __call($name, array $arguments)
    {
        $accessor = substr($name, 0, 3);
        $fieldname = substr($name, 3);

        if (array_key_exists($fieldname, $this->_fields) === false) {
            throw new Opus_Model_Exception('Unknown field: ' . $fieldname);
        }

        switch ($accessor) {
            case 'get':
                return $this->_fields[$fieldname]->getValue();
                break;

            case 'set':
                if (empty($arguments) === true) {
                    throw new Opus_Model_Exception('Argument required for setter function!');
                }
                $this->_fields[$fieldname]->setValue($arguments[0]);
                break;

            default:
                throw new Opus_Model_Exception('Unknown accessor function: ' . $accessor);
                break;
        }

    }


    /**
     * Add an field to the model. If a field with the same name has already been added,
     * it will be replaced by the given field.
     *
     * @param Opus_Model_Field $field                Field instance that gets appended to the models field collection.
     * @param string           $external_model_class (Optional) Name of an external model class.
     * @return Opus_Model_Abstract Provide fluent interface.
     */
    public function addField(Opus_Model_Field $field) {
        $this->_fields[$field->getName()] = $field;
        return $this;
    }


    /**
     * Return a reference to an actual field.
     *
     * @param string $name Name of the requested field.
     * @return Opus_Model_Field The requested field instance. If no such instance can be found, null is returned.
     */
    public function getField($name) {
        if (array_key_exists($name, $this->_fields) === true){
            return $this->_fields[$name];
        } else {
            return null;
        }
    }

    /**
     * Remove the model instance from the database.
     *
     * @see Opus_Model_Interface::delete()
     * @throws Opus_Model_Exception If a delete operation could not be performed on this model.
     * @return void
     */
    public function delete() {
        $this->_primaryTableRow->delete();
        $this->_primaryTableRow = null;
    }

    /**
     * Get the models primary key.
     *
     * @return mixed
     */
    public function getId()
    {
        $tableInfo = $this->_primaryTableRow->getTable()->info();
        $result = array();
        foreach ($tableInfo['primary'] as $primary_key) {
            $result[] = $this->_primaryTableRow->$primary_key;
        }
        if (count($result) > 1) {
            return $result;
        } else if (count($result) === 1) {
            return $result[0];
        } else {
            return null;
        }
    }


    /**
     * Get a list of all fields (internal & external) attached to the model.
     *
     * @return array    List of fields
     */
    public function describe() {
        $fields = array_keys($this->_fields);
        $ex_fields = array_values($this->_externalFields);
        return array_merge($fields, $ex_fields);
    }

}
