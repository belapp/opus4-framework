<?php
/**
 * This file is part of OPUS. The software OPUS has been originally developed
 * at the University of Stuttgart with funding from the German Research Net,
 * the Federal Department of Higher Education and Research and the Ministry
 * of Science, Research and the Arts of the State of Baden-Wuerttemberg.
 *
 * OPUS 4 is a complete rewrite of the original OPUS software and was developed
 * by the Stuttgart University Library, the Library Service Center
 * Baden-Wuerttemberg, the North Rhine-Westphalian Library Service Center,
 * the Cooperative Library Network Berlin-Brandenburg, the Saarland University
 * and State Library, the Saxon State Library - Dresden State and University
 * Library, the Bielefeld University Library and the University Library of
 * Hamburg University of Technology with funding from the German Research
 * Foundation and the European Regional Development Fund.
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
 * @category    Application
 * @author      Thomas Urban <thomas.urban@cepharum.de>
 * @copyright   Copyright (c) 2009-2015, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 * @version     $Id$
 */


/**
 * Implements description of particular search query's result in case of
 * success.
 *
 * @method Opus_Document[] getMatches()
 * @method int getAllMatchesCount()
 */

class Opus_Search_ResultSet {

	protected $data;


	/**
	 * @param Opus_Document[] $matches set of matching documents or set of matching documents' IDs
	 * @param int $allMatchesCount overall number of matches
	 */
	public function __construct( $matches, $allMatchesCount ) {
		if ( !is_array( $matches ) ) {
			throw new InvalidArgumentException( 'invalid set of matches' );
		}

		foreach ( $matches as $key => $match ) {
			if ( !( $match instanceof Opus_Document ) ) {
				if ( !ctype_digit( trim( $match ) ) ) {
					throw new InvalidArgumentException( 'invalid element in set of matches' );
				}

				$matches[$key] = new Opus_Document( $match );
			}
		}

		if ( !ctype_digit( trim( $allMatchesCount ) ) ) {
			throw new InvalidArgumentException( 'invalid number of overall matches' );
		}


		$this->data = array(
			'matches'         => $matches,
			'allmatchescount' => intval( $allMatchesCount ),
		);
	}

	public function __get( $name ) {
		$name = strtolower( trim( $name ) );

		return array_key_exists( $name, $this->data ) ? $this->data[$name] : null;
	}

	public function __isset( $name ) {
		return array_key_exists( $name, $this->data );
	}

	public function __call( $name, $args ) {
		switch ( substr( strtolower( $name ), 0, 3 ) ) {
			case 'get' :
				return $this->__get( substr( $name, 3 ) );
			default :
				throw new RuntimeException( 'invalid call for method: ' . $name );
		}
	}

}
