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
 * @category    Tests
 * @package     Opus_Document
 * @author      Henning Gerhardt (henning.gerhardt@slub-dresden.de)
 * @copyright   Copyright (c) 2008, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 * @version     $Id$
 */


/**
 * Test cases for class Opus_Document_Builder.
 *
 * @category    Tests
 * @package     Opus_Document
 *
 * @group       DocumentBuilderTest
 *
 */
class Opus_Document_BuilderTest extends PHPUnit_Framework_TestCase {

    /**
     * Holds a simple document description.
     *
     * @var string
     */
    private $_xml = '<?xml version="1.0" encoding="UTF-8" ?>
                <documenttype name="doctoral_thesis"
                    xmlns="http://schemas.opus.org/documenttype"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <field name="Language" />
                </documenttype>';

    /**
     * Holds a complex document description.
     *
     * @var string
     */
    private $_xml_complex = '<?xml version="1.0" encoding="UTF-8" ?>
                <documenttype name="doctoral_thesis"
                    xmlns="http://schemas.opus.org/documenttype"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <field name="Language" mandatory="yes" />
                    <field name="TitleMain" multiplicity="2" />
                </documenttype>';

    /**
     * Test if an exception is thrown if no document type is specified.
     *
     * @return void;
     */
    public function testCreatingDocumentWithoutType() {
        $this->setExpectedException('Opus_Document_Exception');
        $builder = new Opus_Document_Builder();
        $document = $builder->create();
    }

    /**
     * Test if calling addFieldsTo without type throws an exception.
     *
     * @return void
     */
    public function testAddingFieldsToDocumentWithoutType() {
        $this->setExpectedException('Opus_Document_Exception');
        $builder = new Opus_Document_Builder();
        $type = new Opus_Document_Type($this->_xml);
        $document = new Opus_Document(null, $type);
        $builder->addFieldsTo($document);
    }

    /**
     * Test if creating of a simple document works.
     *
     * @return void
     */
    public function testCreatingDocument() {
        $type = new Opus_Document_Type($this->_xml);
        $builder = new Opus_Document_Builder($type);
        $document = $builder->create();
        $fields = $document->describe();
        $this->assertTrue(in_array('Language', $fields), 'Document creating failed: Missing field.');
    }

    /**
     * Test if creating a complex document works.
     *
     * @return void
     */
    public function testCreatingComplexDocument() {
        $type = new Opus_Document_Type($this->_xml_complex);
        $builder = new Opus_Document_Builder();
        $document = $builder->create($type);
        $fields = $document->describe();
        
        $this->assertEquals(in_array('Language', $fields), 'Document creating failed: Missing field.'); 
        $this->assertEquals(in_array('TitleMain', $fields), 'Document creating failed: Missing field.');
        
        $mandatory = $document->getField('Language')->isMandatory();
        $this->assertTrue($mandatory, 'Language should be mandatory.');
        
        $mult = $document->getField('TitleMain')->getMultiplicity();
        $this->assertEquals(2, $mult, 'TitleMain should has a mulitplicity of 2.');
    }
}
