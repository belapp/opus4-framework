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
 * @category    Test
 * @package     Opus_Search
 * @author      Oliver Marahrens <o.marahrens@tu-harburg.de>
 * @copyright   Copyright (c) 2008, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 * @version     $Id$
 */

class Opus_Search_DocumentAdapterTest extends PHPUnit_Framework_TestCase {


    /**
     * Test fixture document instance.
     *
     * @var Opus_Model_Document
     */
    protected $_document = null;

    /**
     * Set up a persistent document instance.
     *
     * @return void
     */
    public function setUp() {
        Opus_Document_Type::setXmlDoctypePath(dirname(__FILE__));
        $document = new Opus_Model_Document(null, 'article');

        $title = $document->addTitleMain();
        $title->setValue('Title');
        $title->setLanguage('de');

        $abstract = $document->addTitleAbstract();
        $abstract->setValue('Abstract');
        $abstract->setLanguage('fr');

        $parentTitle = $document->addTitleParent();
        $parentTitle->setValue('Parent');
        $parentTitle->setLanguage('en');

        $isbn = $document->addIsbn();
        $isbn->setValue('123-123-123');

        $note = $document->addNote();
        $note->setMessage('Ich bin eine öffentliche Notiz.');
        $note->setCreator('Jim Knopf');
        $note->setScope('public');

        $patent = $document->addPatent();
        $patent->setCountries('Lummerland');
        $patent->setDateGranted('2008-12-05');
        $patent->setNumber('123456789');
        $patent->setYearApplied('2008');
        $patent->setApplication('Absolutely none.');

        $enrichment = $document->addEnrichment();
        $enrichment->setValue('Poor enrichment.');
        $enrichment->setType('nonesense');

        $author = new Opus_Model_Person();
        $author->setFirstName('Ludwig');
        $author->setLastName('Wittgenstein');
        $author->setDateOfBirth('1889-04-26 00:00:00');
        $author->setPlaceOfBirth('Wien');
        $document->addPersonAuthor($author);

        $author = new Opus_Model_Person();
        $author->setFirstName('Ferdinand');
        $author->setLastName('de Saussure');
        $author->setDateOfBirth('1857-11-26 00:00:00');
        $author->setPlaceOfBirth('Genf');
        $document->addPersonAuthor($author);

        $licence = new Opus_Model_Licence;
        $licence->setActive(1);
        $licence->setLanguage('de');
        $licence->setLinkLicence('http://creativecommons.org/');
        $licence->setMimeType('text/pdf');
        $licence->setNameLong('Creative Commons');
        $licence->setPodAllowed(1);
        $licence->setSortOrder(0);
        $document->addLicence($licence);

        $title2 = $document->addTitleMain();
        $title2->setValue('Title Two');
        $title2->setLanguage('en');
        $abstract2 = $document->addTitleAbstract();
        $abstract2->setValue('Kurzfassung');
        $abstract2->setLanguage('de');
        $document->store();

        $this->_document = $document;
    }

    /**
     * Remove the created document instance.
     *
     * @return void
     */
    public function tearDown() {
        $this->_document->delete();
    }

    /**
     * Test if the structure of Documentdata from the DB is valid for Opus_Search
     *
     * @param Opus_Search_Adapter_DocumentAdapter $document Document from the database
     * @return void
     *
     * @dataProvider oneRealDoc
     */
	public function testDocumentAdapterFromDb() {
	    $adapter = new Opus_Search_Adapter_DocumentAdapter((int)$this->_document->getId());
		$docData = $adapter->getDocument();

        $this->assertFalse(empty($docData), 'No document information returned.');
		$this->assertArrayHasKey('author', $docData, 'Author information is missing.');
		$this->assertArrayHasKey('title', $docData, 'Title information is missing.');
		$this->assertArrayHasKey('urn', $docData, 'URN information is missing.');
		$this->assertArrayHasKey('year', $docData, 'Year information is missing.');
		$this->assertArrayHasKey('abstract', $docData, 'Abstract information is missing.');
	}

}
