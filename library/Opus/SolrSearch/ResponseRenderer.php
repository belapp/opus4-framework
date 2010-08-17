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
 * @category    TODO
 * @package     Opus_SolrSearch
 * @author      Sascha Szott <szott@zib.de>
 * @copyright   Copyright (c) 2008-2010, OPUS 4 development team
 * @license     http://www.gnu.org/licenses/gpl.html General Public License
 * @version     $Id$
 */

class Opus_SolrSearch_ResponseRenderer {
    /**
     * Logger
     *
     * @var Zend_Log
     */
    private $log;

    /**
     * @var Opus_SolrSearch_ResultList
     */
    private $resultList;

    /**
     * @var array
     */
    private $jsonResponse;

    /**
     *
     * @param Apache_Solr_Response $solrResponse
     */
    public function  __construct($solrResponse) {
        $this->log = Zend_Registry::get('Zend_Log');
        $this->setJsonResponseAsArray($solrResponse);
        $this->buildResultList($solrResponse);        
    }

    /**
     * @return Opus_SolrSearch_ResultList
     */
    public function getResultList() {
        return $this->resultList;
    }

    /**
     * @param Apache_Solr_Response $solrResponse
     */
    private function buildResultList($solrResponse) {
        if (is_null($solrResponse->response) || $solrResponse->response->numFound == 0) {
            $this->resultList = new Opus_SolrSearch_ResultList();
            return;
        }
        $results = array();
        foreach ($solrResponse->response->docs as $doc) {
            $result = new Opus_SolrSearch_Result();
            $result->setId($doc->id);
            $result->setScore($doc->score);
            $result->setTitleDeu($doc->title_deu);
            $result->setTitleEng($doc->title_eng);
            $result->setAuthors($doc->author);
            $result->setYear($doc->year);
            $result->setAbstractDeu($doc->abstract_deu);
            $result->setAbstractEng($doc->abstract_eng);                                
            array_push($results, $result);
        }
        $numFound = $solrResponse->response->numFound;
        $qtime = $this->jsonResponse['responseHeader']['QTime'];
        $this->log->debug("number of hits: $numFound");
        $this->log->debug("query time: $qtime");
        $this->resultList = new Opus_SolrSearch_ResultList($results, $numFound, $qtime, $this->getFacets());
    }

    /**
     *
     * @param Apache_Solr_Response $solrResponse
     */
    private function setJsonResponseAsArray($solrResponse) {
        try {
            $this->jsonResponse = Zend_Json::decode($solrResponse->getRawResponse());
            if (is_null($this->jsonResponse)) {
                $this->log->warn("result of decoding solr's json string is null");
            }
        }
        catch (Exception $e) {
            $this->log->warn("error while decoding solr's json response");            
        }
    }

    private function getFacets() {
        $facets = $this->jsonResponse['facet_counts']['facet_fields'];       
        $facetItems = array();
        foreach ($this->getFacet($facets, 'year') as $text => $count) {
            array_push($facetItems, $facetItem = new Opus_SolrSearch_FacetItem($text, $count));
        }
        //$yearFacet = new Opus_SolrSearch_Facet('year', $facetItems);
        return array( "year" => $facetItems);
    }

    private function getFacet($facets, $facetName) {
        if (array_key_exists($facetName, $facets)) {
            return $facets[$facetName];
        }
        return array();
    }
}
?>