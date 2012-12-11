<?php

require_once 'pxfusion.civix.php';
require_once 'CRM/Core/Payment.php';

error_log('extension loaded');

/**
 * Implementation of hook_civicrm_config
 */
function pxfusion_civicrm_config(&$config) {
  _pxfusion_civix_civicrm_config($config);
}

/**
 * Implementation of hook_civicrm_xmlMenu
 *
 * @param $files array(string)
 */
function pxfusion_civicrm_xmlMenu(&$files) {
  _pxfusion_civix_civicrm_xmlMenu($files);
}

/**
 * Implementation of hook_civicrm_install
 */
function pxfusion_civicrm_install() {
  return _pxfusion_civix_civicrm_install();
}

/**
 * Implementation of hook_civicrm_uninstall
 */
function pxfusion_civicrm_uninstall() {
  return _pxfusion_civix_civicrm_uninstall();
}

/**
 * Implementation of hook_civicrm_enable
 */
function pxfusion_civicrm_enable() {
  return _pxfusion_civix_civicrm_enable();
}

/**
 * Implementation of hook_civicrm_disable
 */
function pxfusion_civicrm_disable() {
  return _pxfusion_civix_civicrm_disable();
}

/**
 * Implementation of hook_civicrm_upgrade
 *
 * @param $op string, the type of operation being performed; 'check' or 'enqueue'
 * @param $queue CRM_Queue_Queue, (for 'enqueue') the modifiable list of pending up upgrade tasks
 *
 * @return mixed  based on op. for 'check', returns array(boolean) (TRUE if upgrades are pending)
 *                for 'enqueue', returns void
 */
function pxfusion_civicrm_upgrade($op, CRM_Queue_Queue $queue = NULL) {
  return _pxfusion_civix_civicrm_upgrade($op, $queue);
}

/**
 * Implementation of hook_civicrm_managed
 *
 * Generate a list of entities to create/deactivate/delete when this module
 * is installed, disabled, uninstalled.
 */
function pxfusion_civicrm_managed(&$entities) {
  return _pxfusion_civix_civicrm_managed($entities);
}

class nz_co_giantrobot_PxFusion extends CRM_Core_Payment {
  
  /**
   * We only need one instance of this object. So we use the singleton
   * pattern and cache the instance in this variable
   *
   * @var object
   * @static
   */
  static private $_singleton = null;

  /**
   * Mode of operation: live or test.
   *
   * @var object
   * @static
   */
  static protected $_mode = NULL;
  
  /**
   * Constructor.
   *
   * @param string $mode live or test.
   * @param string $paymentProcessor 
   * @return void
   */
  function __construct($mode, &$paymentProcessor) {
    $this->_mode             = $mode;   // live or test
    $this->_paymentProcessor = $paymentProcessor;
    $this->_processorName    = 'PxFusion';
  }
  
  /** 
   * singleton function used to manage this object 
   * 
   * @param string $mode the mode of operation: live or test.
   * @param object $paymentProcessor the payment processor.
   *
   * @return object 
   * @static 
   * 
   */ 
  static function &singleton($mode, &$paymentProcessor) {
    $processorName = $paymentProcessor['name'];
    if (self::$_singleton[$processorName] === null ) {
      self::$_singleton[$processorName] = new nz_co_giantrobot_pxfusion($mode, $paymentProcessor);
    }
    return self::$_singleton[$processorName];
  }

  /**
   * Validate configuration values.
   *
   * @return NULL | string errors
   */
  function checkConfig() {
    error_log('extension chkconfig hook fired');
    $config =& CRM_Core_Config::singleton();
    $errors = array();

    CRM_Core_Region::instance('billing-block')->update('default', array('disabled' => TRUE));
    CRM_Core_Region::instance('page-body')->add(array(
        'markup' => 'This is the page body.',
      ));
    
    if (!empty($errors)) {
      return implode('<p>', $errors);
    }
  }

  /**
   * Implement doDirectPayment method. Not sure about this.
   */
  function doDirectPayment(&$params) {
    
  }

}

