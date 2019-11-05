<div class="control-group">
    <label class="control-label" for="mo_mode">{__("sl_paylike.mode")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][mode]" id="mo_mode">
            <option value="test" {if $processor_params.mode=='test'}selected="selected"{/if}>Test</option>
            <option value="live" {if $processor_params.mode=='live'}selected="selected"{/if}>Live</option>
        </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_test_public_key">{__("sl_paylike.test_public_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][test_public_key]" id="mo_test_public_key" value="{$processor_params.test_public_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_test_private_key">{__("sl_paylike.test_private_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][test_private_key]" id="mo_test_private_key" value="{$processor_params.test_private_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_public_key">{__("sl_paylike.public_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][public_key]" id="mo_public_key" value="{$processor_params.public_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_private_key">{__("sl_paylike.private_key")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][private_key]" id="mo_private_key" value="{$processor_params.private_key}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_merchant_name">{__("sl_paylike.merchant_name")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][merchant_name]" id="mo_merchant_name" value="{$processor_params.merchant_name}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_descriptor">{__("sl_paylike.descriptor")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][descriptor]" id="mo_descriptor" value="{$processor_params.descriptor}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_popup_title">{__("sl_paylike.popup_title")}:</label>
    <div class="controls">
        <input type="text" name="payment_data[processor_params][popup_title]" id="mo_popup_title" value="{$processor_params.popup_title}" class="input-text" size="60" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_currency">{__("sl_paylike.currency")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][currency]" id="mo_currency">
            {foreach from=sl_paylike_currencies() item="cn" key="cc"}
                <option {if $processor_params.currency==$cc}selected="selected"{/if} value="{$cc}">{$cn} ({$cc})</option>
            {/foreach}
        </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_checkout_mode">{__("sl_paylike.checkout_mode")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][checkout_mode]" id="mo_checkout_mode">
            <option value="delayed" {if $processor_params.checkout_mode=='delayed'}selected="selected"{/if}>Delayed</option>
            <option value="instant" {if $processor_params.checkout_mode=='instant'}selected="selected"{/if}>Instant</option>
        </select>

    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_delayed_status">{__("sl_paylike.delayed_status")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][delayed_status]" id="mo_delayed_status">
            {foreach from=sl_paylike_get_order_statuses_list() item="n" key="k"}
                <option value="{$k}" {if $processor_params.delayed_status==$k}selected="selected"{/if}>{$n}</option>
            {/foreach}
        </select>
        <p>{__("sl_paylike.delayed_status_help")}</p>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="mo_capture_status">{__("sl_paylike.capture_status")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][capture_status]" id="mo_capture_status">
            {foreach from=sl_paylike_get_order_statuses_list() item="n" key="k"}
            <option value="{$k}" {if $processor_params.capture_status==$k}selected="selected"{/if}>{$n}</option>
            {/foreach}
        </select>
        <p>{__("sl_paylike.capture_status_help")}</p>
    </div>
</div>


<div class="control-group">
    <label class="control-label" for="mo_capture_status">{__("sl_paylike.void_status")}:</label>
    <div class="controls">
        <select name="payment_data[processor_params][void_status]" id="mo_void_status">
            {foreach from=sl_paylike_get_order_statuses_list() item="n" key="k"}
                <option value="{$k}" {if $processor_params.void_status==$k}selected="selected"{/if}>{$n}</option>
            {/foreach}
        </select>
        <p>{__("sl_paylike.void_status_help")}</p>
    </div>
</div>
