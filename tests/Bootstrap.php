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
 * @author      Ralf Claussnitzer <ralf.claussnitzer@slub-dresden.de>
 * @author      Thoralf Klein <thoralf.klein@zib.de>
 * @copyright   Copyright (c) 2008-2010, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 * @version     $Id$
 */
// Setup error reporting.
error_reporting(E_ALL | E_STRICT);
ini_set('display_errors', 1);

// Configure include path.
set_include_path('.' . PATH_SEPARATOR
        . PATH_SEPARATOR . dirname(__FILE__)
        . PATH_SEPARATOR . dirname(dirname(__FILE__)) . '/library'
        . PATH_SEPARATOR . get_include_path());

// Zend_Loader is'nt available yet. We have to do a require_once in order
// to find the bootstrap class.
require_once 'Opus/Bootstrap/Base.php';

/**
 * This class provides a static initializiation method for setting up                                                                                                                                              
 * a test environment including php include path, configuration and                                                                                                                                                
 * database setup.                                                                                                                                                                                                 
 *                                                                                                                                                                                                                 
 * @category    Tests                                                                                                                                                                                              
 */
class TestHelper extends Opus_Bootstrap_Base {

    /**
     * Add setting up database and logging facilities.
     *
     * @return void
     * @see library/Opus/Bootstrap/Opus_Bootstrap_Base#_setupBackend()
     */
    protected function _setupBackend() {
        $this->_setupLogging();
        $this->_setupTemp();
        $this->_setupDatabase();

        // FIXME: This should be done in Opus_Bootstrap_Base
        $this->_setupLocale();
    }

    /**
     * Setup timezone and default locale.
     *
     * Registers locale with key Zend_Locale as mentioned in the ZF documentation.
     *
     * @return void
     *
     */
    protected function _setupLocale() {
        /*
         * Setup timezone and locale options.
         */
        date_default_timezone_set('Europe/Berlin');

        // This avoids an exception if the locale cannot determined automatically.
        $locale = new Zend_Locale('de');
        Zend_Registry::set('Zend_Locale', $locale);
    }

}

// Do test environment initializiation.
$application = new TestHelper();
$application->run(dirname(__FILE__), Opus_Bootstrap_Base::CONFIG_TEST);