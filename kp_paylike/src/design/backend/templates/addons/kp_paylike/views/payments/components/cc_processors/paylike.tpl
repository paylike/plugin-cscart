<div class="control-group">
    <label class="control-label" for="mo_mode">{__("kp_paylike.mode")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][mode]" id="mo_mode">
            <option value="test" {if $processor_params.mode=='test'}selected="selected"{/if}>Test</option>
            <option value="live" {if $processor_params.mode=='live'}selected="selected"{/if}>Live</option>
        </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_test_public_key">{__("kp_paylike.test_public_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][test_public_key]" id="mo_test_public_key" value="{$processor_params.test_public_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_test_private_key">{__("kp_paylike.test_private_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][test_private_key]" id="mo_test_private_key" value="{$processor_params.test_private_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_public_key">{__("kp_paylike.public_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][public_key]" id="mo_public_key" value="{$processor_params.public_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_private_key">{__("kp_paylike.private_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][private_key]" id="mo_private_key" value="{$processor_params.private_key}" class="input-text" size="60" />
    </div>
</div>
{*
<div class="control-group">
    <label class="control-label" for="mo_merchant_name">{__("kp_paylike.merchant_name")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][merchant_name]" id="mo_merchant_name" value="{$processor_params.merchant_name}" class="input-text" size="60" />
    </div>
</div>
*}
{*
<div class="control-group">
    <label class="control-label" for="mo_descriptor">{__("kp_paylike.descriptor")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][descriptor]" id="mo_descriptor" value="{$processor_params.descriptor}" class="input-text" size="60" />
    </div>
</div>
*}

{$p_popup_title = $processor_params.popup_title|default:$settings.Company.company_name}
<div class="control-group">
    <label class="control-label" for="mo_popup_title">{__("kp_paylike.popup_title")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][popup_title]" id="mo_popup_title" value="{$p_popup_title}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_currency">{__("kp_paylike.currency")}:</label>
    <div class="controls">
        {$p_cur= $processor_params.currency|default:$primary_currency}
        <select name="payment_data[processor_params][currency]" id="mo_currency">
            {foreach from=kp_paylike_currencies() item="cn" key="cc"}
                <option {if $p_cur==$cc}selected="selected"{/if} value="{$cc}">{$cn} ({$cc})</option>
            {/foreach}
        </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_checkout_mode">{__("kp_paylike.checkout_mode")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][checkout_mode]" id="mo_checkout_mode">
            <option value="delayed" {if $processor_params.checkout_mode=='delayed'}selected="selected"{/if}>Delayed</option>
            <option value="instant" {if $processor_params.checkout_mode=='instant'}selected="selected"{/if}>Instant</option>
        </select>

    </div>
</div>
{$p_delayed_status=$processor_params.delayed_status|default:"P"}
<div class="control-group">
    <label class="control-label" for="mo_delayed_status">{__("kp_paylike.delayed_status")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][delayed_status]" id="mo_delayed_status">
            {foreach from=kp_paylike_get_order_statuses_list() item="n" key="k"}
                <option value="{$k}" {if $p_delayed_status==$k}selected="selected"{/if}>{$n}</option>
            {/foreach}
        </select>
        <p>{__("kp_paylike.delayed_status_help")}</p>
    </div>
</div>

{$p_capture_status=$processor_params.capture_status|default:"C"}
<div class="control-group">
    <label class="control-label" for="mo_capture_status">{__("kp_paylike.capture_status")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][capture_status]" id="mo_capture_status">
            {foreach from=kp_paylike_get_order_statuses_list() item="n" key="k"}
            <option value="{$k}" {if $p_capture_status==$k}selected="selected"{/if}>{$n}</option>
            {/foreach}
        </select>
        <p>{__("kp_paylike.capture_status_help")}</p>
    </div>
</div>

{$p_void_status=$processor_params.void_status|default:"I"}
<div class="control-group">
    <label class="control-label" for="mo_capture_status">{__("kp_paylike.void_status")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][void_status]" id="mo_void_status">
            {foreach from=kp_paylike_get_order_statuses_list() item="n" key="k"}
                <option value="{$k}" {if $p_void_status==$k}selected="selected"{/if}>{$n}</option>
            {/foreach}
        </select>
        <p>{__("kp_paylike.void_status_help")}</p>
    </div>
</div>
