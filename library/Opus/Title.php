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
 * @package     Opus
 * @author      Felix Ostrowski (ostrowski@hbz-nrw.de)
 * @author      Ralf Claußnitzer (ralf.claussnitzer@slub-dresden.de)
 * @author      Jens Schwidder <schwidder@zib.de>
 * @copyright   Copyright (c) 2008-2018, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 */

/**
 * Domain model for titles in the Opus framework
 *
 * @category    Framework
 * @package     Opus
 * @uses        Opus_Model_Abstract
 *
 * @method void setLanguage(string $lang)
 * @method string getLanguage()
 *
 * @method void setValue(string $value)
 * @method string getValue()
 *
 * @method void setType(string $type)
 * @method string getType()
 */
class Opus_Title extends Opus_Model_Dependent_Abstract
{

    const TYPE_MAIN = 'main';

    const TYPE_PARENT = 'parent';

    const TYPE_SUB = 'sub';

    const TYPE_ADDITIONAL = 'additional';

    /**
     * Primary key of the parent model.
     *
     * @var mixed $_parentId.
     */
    protected $_parentColumn = 'document_id';

    /**
     * Specify then table gateway.
     *
     * @var string Classname of Zend_DB_Table to use if not set in constructor.
     */
    protected static $_tableGatewayClass = 'Opus_Db_DocumentTitleAbstracts';

    /**
     * Initialize model with the following fields:
     * - Language
     * - Title
     *
     * @return void
     */
    protected function _init()
    {
        $language = new Opus_Model_Field('Language');
        if (Zend_Registry::isRegistered('Available_Languages') === true) {
            $language->setDefault(Zend_Registry::get('Available_Languages'));
        }
        $language->setSelection(true);
        $language->setMandatory(true);
        $value = new Opus_Model_Field('Value');
        $value->setMandatory(true)
            ->setValidator(new Zend_Validate_NotEmpty())
            ->setTextarea(true);

        $type = new Opus_Model_Field('Type');
        $type->setMandatory(false);
        $type->setSelection(true);
        $type->setDefault([
            'main' => 'main',
            'parent' => 'parent',
            'sub' => 'sub',
            'additional' => 'additional'
        ]);

        $this->addField($language)
            ->addField($value)
            ->addField($type);
    }
}
