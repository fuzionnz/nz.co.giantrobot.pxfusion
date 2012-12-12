<?php

/**
 * @file
 * PxFusion client library for PHP.
 */

/**
 * Class for handling PxFusion transactions.
 */
class PxFusion {
  // DPS Px Fusion Details
  public $fusion_username = '';
  public $fusion_password = '';
  protected $wsdl = 'https://sec.paymentexpress.com/pxf/pxf.svc?wsdl';

  // Variables/Objects that are used to hold data for transactions
  public $tranDetail;
  protected $soap_client;

  public function __construct($params) {
    dpm($params, 'params');
    if (isset($params['username'])) {
      $this->fusion_username = $params['username'];
    }
    if (isset($params['password'])) {
      $this->fusion_password = $params['password'];
    }
    if (!is_object($this->tranDetail)) {
      $this->tranDetail = new stdClass();
    }
  }

  public function set_txn_detail($property, $value) {
    $this->tranDetail->$property = $value;
  }

  public function get_transaction_id() {
    $this->soap_client = new SoapClient($this->wsdl, array('soap_version' => SOAP_1_1));

    // SoapClient does some magic conversion from array into the required soap+xml format
    $array_for_soap = array(
      'username' => $this->fusion_username,
      'password' => $this->fusion_password,
      'tranDetail' => get_object_vars($this->tranDetail) // extracts all properties of object into associative array
    );

    $response = $this->soap_client->GetTransactionId($array_for_soap);
    return $response;
  }

  public function get_transaction($transaction_id) {
    $this->soap_client = new SoapClient($this->wsdl, array('soap_version' => SOAP_1_1));
    $array_for_soap = array(
      'username' => $this->fusion_username,
      'password' => $this->fusion_password,
      'transactionId' => $transaction_id
    );
    
    $response = $this->soap_client->GetTransaction($array_for_soap);
    return $response;
  }
}