<?php
/**
 * @copyright 2019 Paylike.com.
 * @author Panos <panos@Paylike.com>
 * Date: 17/9/2019
 * Time: 11:28 πμ
 */

namespace Paylike;

use Tygh\Enum\OrderDataTypes;

class CaptureDelayed {

    public function capture(&$order_info, $txnId) {

        $processor_data = fn_get_processor_data($order_info['payment_id']);
        $private_key = $processor_data['processor_params']['private_key'];
        if($processor_data['processor_params']['mode']=='test') {
            $private_key = $processor_data['processor_params']['test_private_key'];
        }
        \Paylike\Client::setKey( $private_key );
        $currency_multiplier = \Paylike\Currency::getPaylikeCurrencyMultiplier($processor_data['processor_params']['currency']);
        $cart_amount = \Paylike\Currency::toPaylikeCurrency($order_info['total'],$currency_multiplier);
        $data = array(
            'currency'   => $processor_data['processor_params']['currency'],
            'amount'     => $cart_amount,
        );
        $capture = \Paylike\Transaction::capture( $txnId, $data );
        $update = false;
        $pp_response = [];
        if ( is_array( $capture ) && ! isset( $capture['transaction'] ) ) {
            $message = implode(',', $capture);
            $pp_response['reason_text'] = $message;
            $update = true;
        } elseif ( ! empty( $capture['transaction'] ) ) {
            $message = __('sl_paylike.trx_id').':' . $txnId .
                __('sl_paylike.authorized_amount').':' . ( $capture['transaction']['amount'] / $currency_multiplier ) .
                __('sl_paylike.captured_amount').':'. ( $capture['transaction']['capturedAmount'] / $currency_multiplier ) .
                __('sl_paylike.order_time').':'. $capture['transaction']['created'] .
                __('sl_paylike.currency_code').':'. $capture['transaction']['currency'];
            $pp_response['reason_text'] = $message;
            $pp_response['transaction_id'] = $txnId;
            $pp_response['captured'] = 'Y';
            $pp_response['amount_capt'] = $capture['transaction']['capturedAmount'] / $currency_multiplier ;
            $update = true;
        }
        if($update) {
            fn_update_order_payment_info($order_info['order_id'], $pp_response);
            $order_info['payment_info'] = $this->reloadPaymentInfo($order_info['order_id']);
        }
    }

    public function refund(&$order_info, $txnId, $amount) {
        $processor_data = fn_get_processor_data($order_info['payment_id']);
        $private_key = $processor_data['processor_params']['private_key'];
        if($processor_data['processor_params']['mode']=='test') {
            $private_key = $processor_data['processor_params']['test_private_key'];
        }
        \Paylike\Client::setKey( $private_key );
        $currency_multiplier = \Paylike\Currency::getPaylikeCurrencyMultiplier($processor_data['processor_params']['currency']);
        $cart_amount = \Paylike\Currency::toPaylikeCurrency($amount,$currency_multiplier);
        $data = array(
            'amount'     => $cart_amount,
            'descriptor'   => $processor_data['processor_params']['descriptor'],
        );
        $capture = \Paylike\Transaction::refund( $txnId, $data );
        if ( is_array( $capture ) && ! isset( $capture['transaction'] ) ) {
            $message = implode(',', $capture);
            $pp_response['reason_text'] = $message;
            $update = true;
        } elseif ( ! empty( $capture['transaction'] ) ) {
            $message = __('sl_paylike.trx_id').':' . $txnId .
                __('sl_paylike.authorized_amount').':' . ( $capture['transaction']['amount'] / $currency_multiplier ) .
                __('sl_paylike.captured_amount').':'. ( $capture['transaction']['capturedAmount'] / $currency_multiplier ) .
                __('sl_paylike.refunded_amount').':'. ( $capture['transaction']['refundedAmount'] / $currency_multiplier ) .
                __('sl_paylike.order_time').':'. $capture['transaction']['created'] .
                __('sl_paylike.currency_code').':'. $capture['transaction']['currency'];
            $pp_response['reason_text'] = $message;
            $pp_response['transaction_id'] = $txnId;
            $pp_response['captured'] = 'Y';
            $pp_response['amount_refu'] = $capture['transaction']['refundedAmount'] / $currency_multiplier ;
            $pp_response['refunded'] = 'Y';
            $update = true;
        }
        if($update) {
            fn_update_order_payment_info($order_info['order_id'], $pp_response);
            $order_info['payment_info'] = $this->reloadPaymentInfo($order_info['order_id']);
        }
    }


    public function void(&$order_info, $txnId) {
        $amount = $order_info['total'];
        $processor_data = fn_get_processor_data($order_info['payment_id']);
        $private_key = $processor_data['processor_params']['private_key'];
        if($processor_data['processor_params']['mode']=='test') {
            $private_key = $processor_data['processor_params']['test_private_key'];
        }
        \Paylike\Client::setKey( $private_key );
        $currency_multiplier = \Paylike\Currency::getPaylikeCurrencyMultiplier($processor_data['processor_params']['currency']);
        $cart_amount = \Paylike\Currency::toPaylikeCurrency($amount,$currency_multiplier);
        $data = array(
            'amount'     => $cart_amount,
        );
        $capture = \Paylike\Transaction::void( $txnId, $data );
        if ( is_array( $capture ) && ! isset( $capture['transaction'] ) ) {
            $message = implode(',', $capture);
            $pp_response['reason_text'] = $message;
            $update = true;
        } elseif ( ! empty( $capture['transaction'] ) ) {
            $message = __('sl_paylike.trx_id').':' . $txnId .
                __('sl_paylike.captured_amount').':'. ( $capture['transaction']['capturedAmount'] / $currency_multiplier ) .
                ' Void Amount: ' . ( $capture['transaction']['voidedAmount'] / $currency_multiplier ) .
                __('sl_paylike.order_time').':'. $capture['transaction']['created'] .
                __('sl_paylike.currency_code').':'. $capture['transaction']['currency'];
            $pp_response['reason_text'] = $message;
            $pp_response['transaction_id'] = $txnId;
            $pp_response['captured'] = 'N';
            $pp_response['voided_amount'] = $capture['transaction']['voidedAmount'] / $currency_multiplier ;
            $pp_response['voided'] = 'Y';
            $update = true;
        }
        if($update) {
            fn_update_order_payment_info($order_info['order_id'], $pp_response);
            $order_info['payment_info'] = $this->reloadPaymentInfo($order_info['order_id']);
        }
    }

    private function reloadPaymentInfo($order_id) {
        $paymentInfo = false;
        $additional_data = db_get_hash_single_array("SELECT type, data FROM ?:order_data WHERE order_id = ?i", array('type', 'data'), $order_id);
        if (!empty($additional_data[OrderDataTypes::PAYMENT])) {
            $paymentInfo = unserialize(fn_decrypt_text($additional_data[OrderDataTypes::PAYMENT]));
        }
        return $paymentInfo;
    }
}