<html>

<head>

</head>
<body>

<h1>{__("sl_paylike.pay_your_order")}</h1>
<div class="pls-wait" style="display: none; text-align: center; font-size: 14px;">{__("sl_paylike.we_are_processing_your_payment_text")}</div>

{scripts}
    <script src="https://sdk.paylike.io/3.js"></script>
<script>
    var paylike = Paylike('{$public_key}');


    function pay(){
        paylike.popup({
            currency: '{$processor_data.processor_params.currency}',
            amount: '{$total}',
            title: '{$processor_data.processor_params.popup_title}',
            {if $processor_data.processor_params.descriptor}
            descriptor: '{$processor_data.processor_params.descriptor}',
            {/if}
            custom: {
                order_id: '{$order_id}',
                customer: {
                    email: '{$customer.email}',
                    phone: '{$customer.phone}',
                    address: '{$customer.address}',
                    city: '{$customer.city}',
                    zip: '{$customer.zip}',
                    state: '{$customer.state}',
                    country: '{$customer.country}'
                },
                platform: {
                    name: '{$platform.name}',
                    version: '{$platform.version}'
                },
                module: {
                    name: '{$platform.addon_name}',
                    version: '{$platform.addon_version}'
                }

            }
        }, function( err, r ){
            var x = document.getElementsByClassName("pls-wait");
            for (i = 0; i < x.length; i++) {
                x[i].style.display = "block";
            }
            if(err) {
                if(err=='closed') {
                    window.location.href = '{$canceled_url nofilter}';
                }
            }
            if(r.transaction) {
                window.location.href = '{$payed_url nofilter}&txn='+r.transaction.id;
            }
        });
    }

    (function() {
        pay();
    })();
</script>
{/scripts}

</body>

</html>

