{*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.2                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2012                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}
{if $action & 1024}
    {include file="CRM/Contribute/Form/Contribution/PreviewHeader.tpl"}
{/if}

{include file="CRM/common/TrackingFields.tpl"}

<div class="crm-block crm-contribution-confirm-form-block">
    <div id="help">
        <p>{ts}Please verify the information below carefully. Click <strong>Go Back</strong> if you need to make changes.{/ts}
            {if $contributeMode EQ 'notify' and ! $is_pay_later}
                {if $paymentProcessor.payment_processor_type EQ 'Google_Checkout'}
                    {ts}Click the <strong>Google Checkout</strong> button to checkout to Google, where you will select your payment method and complete the contribution.{/ts}
                {elseif $paymentProcessor.payment_processor_type EQ 'PxFusion'}
                    {ts}Complete the form below to complete your contribution.{/ts}
                {else}
                    {ts 1=$paymentProcessor.processorName 2=$button}Click the <strong>%2</strong> button to go to %1, where you will select your payment method and complete the contribution.{/ts}
                {/if}
            {elseif ! $is_monetary or $amount LE 0.0 or $is_pay_later}
                {ts 1=$button}To complete this transaction, click the <strong>%1</strong> button below.{/ts}
            {else}
                {ts 1=$button}To complete your contribution, click the <strong>%1</strong> button below.{/ts}
            {/if}
        </p>
    </div>
{if $paymentProcessor.payment_processor_type NEQ 'PxFusion'}
    <div id="crm-submit-buttons" class="crm-submit-buttons">
        {include file="CRM/common/formButtons.tpl" location="top"}
    </div>
{/if}
    {if $is_pay_later}
        <div class="bold pay_later_receipt-section">{$pay_later_receipt}</div>
    {/if}

    {include file="CRM/Contribute/Form/Contribution/MembershipBlock.tpl" context="confirmContribution"}

    {if $amount GT 0 OR $minimum_fee GT 0 OR ( $priceSetID and $lineItem ) }
    <div class="crm-group amount_display-group">
       {if !$useForMember}
        <div class="header-dark">
             {if !$membershipBlock AND $amount OR ( $priceSetID and $lineItem ) }{ts}Contribution Amount{/ts}{else}{ts}Membership Fee{/ts} {/if}
        </div>
        {/if}
        <div class="display-block">
            {if !$useForMember}
              {if $lineItem and $priceSetID}
                {if !$amount}{assign var="amount" value=0}{/if}
                {assign var="totalAmount" value=$amount}
                {include file="CRM/Price/Page/LineItem.tpl" context="Contribution"}
              {elseif $is_separate_payment }
                {if $amount AND $minimum_fee}
                    {$membership_name} {ts}Membership{/ts}: <strong>{$minimum_fee|crmMoney}</strong><br />
                    {ts}Additional Contribution{/ts}: <strong>{$amount|crmMoney}</strong><br />
                    <strong> -------------------------------------------</strong><br />
                    {ts}Total{/ts}: <strong>{$amount+$minimum_fee|crmMoney}</strong><br />
                {elseif $amount }
                    {ts}Amount{/ts}: <strong>{$amount|crmMoney} {if $amount_level } - {$amount_level} {/if}</strong>
                {else}
                    {$membership_name} {ts}Membership{/ts}: <strong>{$minimum_fee|crmMoney}</strong>
                {/if}
              {else}
                {if $amount }
                    {ts}Total Amount{/ts}: <strong>{$amount|crmMoney} {if $amount_level } - {$amount_level} {/if}</strong>
                {else}
                    {$membership_name} {ts}Membership{/ts}: <strong>{$minimum_fee|crmMoney}</strong>
                {/if}
              {/if}
            {/if}

            {if $is_recur}
                {if $membershipBlock} {* Auto-renew membership confirmation *}
                    <br />
                    <strong>{ts 1=$frequency_interval 2=$frequency_unit}I want this membership to be renewed automatically every %1 %2(s).{/ts}</strong></p>
                    <div class="description crm-auto-renew-cancel-info">({ts}Your initial membership fee will be processed once you complete the confirmation step. You will be able to cancel the auto-renwal option by visiting the web page link that will be included in your receipt.{/ts})</div>
                {else}
                    {if $installments}
                        <p><strong>{ts 1=$frequency_interval 2=$frequency_unit 3=$installments}I want to contribute this amount every %1 %2(s) for %3 installments.{/ts}</strong></p>
                    {else}
                        <p><strong>{ts 1=$frequency_interval 2=$frequency_unit}I want to contribute this amount every %1 %2(s).{/ts}</strong></p>
                    {/if}
                    <p>{ts}Your initial contribution will be processed once you complete the confirmation step. You will be able to cancel the recurring contribution by visiting the web page link that will be included in your receipt.{/ts}</p>
                {/if}
            {/if}
            {if $is_pledge }
                {if $pledge_frequency_interval GT 1}
                    <p><strong>{ts 1=$pledge_frequency_interval 2=$pledge_frequency_unit 3=$pledge_installments}I pledge to contribute this amount every %1 %2s for %3 installments.{/ts}</strong></p>
                {else}
                    <p><strong>{ts 1=$pledge_frequency_interval 2=$pledge_frequency_unit 3=$pledge_installments}I pledge to contribute this amount every %2 for %3 installments.{/ts}</strong></p>
                {/if}
                {if $is_pay_later}
                    <p>{ts 1=$receiptFromEmail 2=$button}Click &quot;%2&quot; below to register your pledge. You will be able to modify or cancel future pledge payments at any time by logging in to your account or contacting us at %1.{/ts}</p>
                {else}
                    <p>{ts 1=$receiptFromEmail 2=$button}Your initial pledge payment will be processed when you click &quot;%2&quot; below. You will be able to modify or cancel future pledge payments at any time by logging in to your account or contacting us at %1.{/ts}</p>
                {/if}
            {/if}
        </div>
    </div>
    {/if}

{if $paymentProcessor.payment_processor_type EQ 'PxFusion'}
{* close HTML_QuickForm form, insert our own *}
    </form>
    <div class="crm-group crm-pxfusion-form">
    <div class="header-dark">Card Details</div>
    <form enctype="multipart/form-data" action="https://sec.paymentexpress.com/pxmi3/pxfusionauth" method="post">
      <input type="hidden" name="SessionId" value="{$pxfusion_sessionid}" />
      <input type="hidden" name="Action" value="Add" />
      <input type="hidden" name="Object" value="DpsPxPay" />
    <table>
    <tr><td> Card Number</td><td><input type="text" name="CardNumber" value="4111111111111111"/></td></tr>
    <tr>
      <td> Expiry</td>
      <td>
        <select name="ExpiryMonth">
            <option value="01">01 - January</option>
            <option value="02">02 - February</option>
            <option value="03">03 - March</option>
            <option value="04">04 - April</option>
            <option value="05">05 - May</option>
            <option value="06">06 - June</option>
            <option value="07">07 - July</option>
            <option value="08">08 - August</option>
            <option value="09">09 - September</option>
            <option value="10">10 - October</option>
            <option value="11">11 - November</option>
            <option value="12">12 - December</option>
        </select>
        <select name="ExpiryYear">
          <option value="2012">2012</option>
          <option value="2013">2013</option>
          <option value="2014">2014</option>
          <option value="2015">2015</option>
          <option value="2016">2016</option>
          <option value="2017">2017</option>
          <option value="2018">2018</option>
          <option value="2019">2019</option>
          <option value="2020">2020</option>
        </select>
      </td></tr>
    <tr><td> Card CVV</td><td><input type="text" name="Cvc2" value="111"/></td></tr>
    <tr><td> Card Name</td><td><input type="text" name="CardHolderName" value="Joe Bloggs"/></td></tr>
    </table>
    <input type="submit" value="Submit" />
    </form>
    </div>
    <form>
{* Re-open form for HTML_QuickForm *}
   <form>
{/if}

    {include file="CRM/Contribute/Form/Contribution/Honor.tpl"}

    {if $customPre}
            <fieldset class="label-left">
                {include file="CRM/UF/Form/Block.tpl" fields=$customPre}
            </fieldset>
    {/if}

    {if $pcpBlock}
    <div class="crm-group pcp_display-group">
        <div class="header-dark">
            {ts}Contribution Honor Roll{/ts}
        </div>
        <div class="display-block">
            {if $pcp_display_in_roll}
                {ts}List my contribution{/ts}
                {if $pcp_is_anonymous}
                    <strong>{ts}anonymously{/ts}.</strong>
                {else}
                    {ts}under the name{/ts}: <strong>{$pcp_roll_nickname}</strong><br/>
                    {if $pcp_personal_note}
                        {ts}With the personal note{/ts}: <strong>{$pcp_personal_note}</strong>
                    {else}
                     <strong>{ts}With no personal note{/ts}</strong>
                     {/if}
                {/if}
            {else}
                {ts}Don't list my contribution in the honor roll.{/ts}
            {/if}
            <br />
        </div>
    </div>
    {/if}

    {if $onbehalfProfile}
      <div class="crm-group onBehalf_display-group">
         {include file="CRM/UF/Form/Block.tpl" fields=$onbehalfProfile}
         <div class="crm-section organization_email-section">
            <div class="label">{ts}Organization Email{/ts}</div>
            <div class="content">{$onBehalfEmail}</div>
            <div class="clear"></div>
         </div>
      </div>
    {/if}

    {if ( $contributeMode ne 'notify' and ! $is_pay_later and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 ) ) or $email }
        {if $contributeMode ne 'notify' and ! $is_pay_later and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 ) }
            <div class="crm-group billing_name_address-group">
                <div class="header-dark">
                    {ts}Billing Name and Address{/ts}
                </div>
                <div class="crm-section no-label billing_name-section">
                        <div class="content">{$billingName}</div>
                        <div class="clear"></div>
                </div>
                <div class="crm-section no-label billing_address-section">
                        <div class="content">{$address|nl2br}</div>
                        <div class="clear"></div>
                </div>
                </div>
        {/if}
        {if $email}
            <div class="crm-group contributor_email-group">
                <div class="header-dark">
                    {ts}Your Email{/ts}
                </div>
                <div class="crm-section no-label contributor_email-section">
                        <div class="content">{$email}</div>
                        <div class="clear"></div>
                </div>
            </div>
        {/if}
    {/if}

                {* Show credit or debit card section for 'direct' mode, except for PayPal Express (detected because credit card number is empty) *}
    {if $contributeMode eq 'direct' and ! $is_pay_later and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 )
                                and ($credit_card_number or $bank_account_number)}
        <div class="crm-group credit_card-group">
            <div class="header-dark">
            {if $paymentProcessor.payment_type & 2}
                 {ts}Direct Debit Information{/ts}
            {else}
                {ts}Credit Card Information{/ts}
            {/if}
            </div>
            {if $paymentProcessor.payment_type & 2}
                <div class="display-block">
                    {ts}Account Holder{/ts}: {$account_holder}<br />
                    {ts}Bank Account Number{/ts}: {$bank_account_number}<br />
                    {ts}Bank Identification Number{/ts}: {$bank_identification_number}<br />
                    {ts}Bank Name{/ts}: {$bank_name}<br />
                </div>
            {else}
                <div class="crm-section no-label credit_card_details-section">
                    <div class="content">{$credit_card_type}</div>
                        <div class="content">{$credit_card_number}</div>
                        <div class="content">{ts}Expires{/ts}: {$credit_card_exp_date|truncate:7:''|crmDate}</div>
                        <div class="clear"></div>
                </div>
            {/if}
        </div>
    {/if}

    {include file="CRM/Contribute/Form/Contribution/PremiumBlock.tpl" context="confirmContribution"}

    {if $customPost}
            <fieldset class="label-left">
                {include file="CRM/UF/Form/Block.tpl" fields=$customPost}
            </fieldset>
    {/if}

    {if $contributeMode eq 'direct' and $paymentProcessor.payment_type & 2}
    <div class="crm-group debit_agreement-group">
        <div class="header-dark">
            {ts}Agreement{/ts}
        </div>
        <div class="display-block">
            {ts}Your account data will be used to charge your bank account via direct debit. While submitting this form you agree to the charging of your bank account via direct debit.{/ts}
        </div>
    </div>
    {/if}

  {if $paymentProcessor.payment_processor_type NEQ 'PxFusion'}
    {if $contributeMode NEQ 'notify' and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 ) } {* In 'notify mode, contributor is taken to processor payment forms next *}
    <div class="messages status continue_instructions-section">
        <p>
        {if $is_pay_later OR $amount LE 0.0}
            {ts 1=$button}Your transaction will not be completed until you click the <strong>%1</strong> button. Please click the button one time only.{/ts}
        {else}
            {ts 1=$button}Your contribution will not be completed until you click the <strong>%1</strong> button. Please click the button one time only.{/ts}
        {/if}
        </p>
    </div>
    {/if}
  {/if}

    {if $paymentProcessor.payment_processor_type EQ 'Google_Checkout' and $is_monetary and ( $amount GT 0 OR $minimum_fee GT 0 ) and ! $is_pay_later}
        <fieldset class="crm-group google_checkout-group"><legend>{ts}Checkout with Google{/ts}</legend>
        <table class="form-layout-compressed">
            <tr>
                <td class="description">{ts}Click the Google Checkout button to continue.{/ts}</td>
            </tr>
            <tr>
                <td>{$form._qf_Confirm_next_checkout.html} <span style="font-size:11px; font-family: Arial, Verdana;">Checkout securely.  Pay without sharing your financial information. </span></td>
            </tr>
        </table>
        </fieldset>
    {/if}

    {if $paymentProcessor.payment_processor_type EQ 'PxFusion'}
       {* We don't offer a "Make Contribution" button, we provide a form shortly. *}
    {else}
      <div id="crm-submit-buttons" class="crm-submit-buttons">
        {include file="CRM/common/formButtons.tpl" location="bottom"}
      </div>
    {/if}
</div>
