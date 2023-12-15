<?php
/**
 * @copyright 2019 Paylike.io.
 * @author Panos <support@cs-cart.sg>
 * Date: 16/9/2019
 * Time: 9:48 πμ
 */

use Tygh\Registry;
use Paylike\Transaction;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if (defined('PAYMENT_NOTIFICATION')) {

    $pp_response = array();
    $pp_response['order_status'] = 'F';
    $pp_response['reason_text'] = __('text_transaction_declined');
    $order_id = !empty($_REQUEST['order_id']) ? (int)$_REQUEST['order_id'] : 0;

    if($mode=='cancel') {
        $pp_response['reason_text'] = __('text_transaction_canceled');
    }
    elseif($mode=='payed') {
        $order_info = fn_get_order_info($order_id);
        $txnId = $_REQUEST['txn'];
        if (empty($processor_data)) {
            $processor_data = fn_get_processor_data($order_info['payment_id']);
        }
        $currency_multiplier = \Paylike\Currency::getPaylikeCurrencyMultiplier($processor_data['processor_params']['currency']);
        $private_key = $processor_data['processor_params']['private_key'];
        if($processor_data['processor_params']['mode']=='test') {
            $private_key = $processor_data['processor_params']['test_private_key'];
        }
        Paylike\Client::setKey( $private_key );

        if($order_info && !empty($txnId)) {
            $cart_amount = \Paylike\Currency::toPaylikeCurrency($order_info['total'], $currency_multiplier);
            if ( $processor_data['processor_params']['checkout_mode'] == 'delayed' ) {
                $fetch = Paylike\Transaction::fetch( $txnId );

                if ( is_array( $fetch ) && !isset( $fetch['transaction'] ) ) {
                    $pp_response['order_status'] = 'F';
                    $pp_response['reason_text'] = implode(',',$fetch);
                }
                elseif ( is_array( $fetch ) && $fetch['transaction']['custom']['order_id']==$order_id) {
                    $total = $fetch['transaction']['amount'] / $currency_multiplier;
                    $amount = $fetch['transaction']['amount'];
                    $pp_response['order_status'] = $processor_data['processor_params']['delayed_status'];

                    $pp_response['reason_text'] = __("delayed");
                    $pp_response['transaction_id'] = $txnId;
                    $pp_response['kp_paylike.order_time'] = kp_paylike_datetime_to_human($fetch['transaction']['created']);
                    $pp_response['kp_paylike.currency_code'] = $fetch['transaction']['currency'];
                    $pp_response['amount_auth'] = $fetch['transaction']['amount'] / $currency_multiplier ;
                    //$pp_response['amount_capt'] = $fetch['transaction']['capturedAmount'] / $currency_multiplier ;
                    $pp_response['captured'] = 'N';
                    array_filter($pp_response);
                }
            } else {

                $data = array(
                    'currency'   => $processor_data['processor_params']['currency'],
                    'amount'     => $cart_amount,
                );
                $capture = Paylike\Transaction::capture( $txnId, $data );

                if ( is_array( $capture ) && ! isset( $capture['transaction'] ) ) {
                    $message = implode(',', $capture);
                    $pp_response['order_status'] = 'F';
                    $pp_response['reason_text'] = $message;
                } elseif ( ! empty( $capture['transaction'] ) ) {
                    $pp_response['order_status'] = 'P';
                    $pp_response['reason_text'] = __("captured");
                    $pp_response['transaction_id'] = $txnId;
                    $pp_response['kp_paylike.order_time'] = kp_paylike_datetime_to_human($capture['transaction']['created']);
                    $pp_response['kp_paylike.currency_code'] = $capture['transaction']['currency'];
                    $pp_response['amount_auth'] = $capture['transaction']['amount'] / $currency_multiplier ;
                    $pp_response['amount_capt'] = $capture['transaction']['capturedAmount'] / $currency_multiplier ;
                    $pp_response['captured'] = 'Y';
                    array_filter($pp_response);
                } else {
                    $transaction_failed = true;
                }
            }

        }
    }

    if (fn_check_payment_script('paylike.php', $order_id)) {
        fn_finish_payment($order_id, $pp_response);
        fn_order_placement_routines('route', $order_id);
    }
}
else {
    $view = Tygh::$app['view'];
    $view->assign('processor_data', $processor_data);
    $view->assign('order_info', $order_info);
    $view->assign('order_id', $order_id);

    $public_key = $processor_data['processor_params']['public_key'];
    if($processor_data['processor_params']['mode']=='test') {
        $public_key = $processor_data['processor_params']['test_public_key'];
    }
    $currency_multiplier = \Paylike\Currency::getPaylikeCurrencyMultiplier($processor_data['processor_params']['currency']);
    $view->assign('public_key', $public_key);
    $view->assign('total', \Paylike\Currency::toPaylikeCurrency($order_info['total'],$currency_multiplier));
    $view->assign('canceled_url', fn_url("payment_notification.cancel?payment=paylike&order_id=$order_id", AREA, 'current'));
    $view->assign('payed_url', fn_url("payment_notification.payed?payment=paylike&order_id=$order_id", AREA, 'current'));
    $customer = [
        'email' => $order_info['email'],
        'phone' => $order_info['phone'],
        'address' => !empty($order_info['b_address']) ? $order_info['b_address'] : $order_info['s_address'],
        'city' => !empty($order_info['b_city']) ? $order_info['b_city'] : $order_info['s_city'],
        'state' => !empty($order_info['b_state']) ? $order_info['b_state'] : $order_info['s_state'],
        'zip' => !empty($order_info['b_zipcode']) ? $order_info['b_zipcode'] : $order_info['s_zipcode'],
        'country' => !empty($order_info['b_country']) ? $order_info['b_country'] : $order_info['s_country'],
    ];
    $view->assign('customer', $customer);
    $platform = [
        'name' => 'CS-CART ' . PRODUCT_NAME,
        'version' => PRODUCT_VERSION,
        'addon_name' => 'Paylike.io CS-Cart Kit',
        'addon_version' => fn_get_addon_version('kp_paylike'),
    ];
    $view->assign('platform', $platform);
    $view->display('addons/kp_paylike/components/payment_page.tpl');
    die(1);
}