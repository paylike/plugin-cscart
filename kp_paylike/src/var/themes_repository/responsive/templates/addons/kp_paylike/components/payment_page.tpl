<html>

<head>

</head>
<body>

<h1>{__("kp_paylike.pay_your_order")}</h1>
<div class="pls-wait" style="display: none; text-align: center; font-size: 14px;">{__("kp_paylike.we_are_processing_your_payment_text")}</div>

{scripts}
<script src="https://code.jquery.com/jquery-3.5.1.min.js" 
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" 
        crossorigin="anonymous" 
        data-no-defer="">
</script>

<script src="https://sdk.paylike.io/6.js"></script>
<script>
    var paylike = Paylike('{$public_key}');


    function pay(){
        paylike.popup({
            currency: '{$processor_data.processor_params.currency}',
            amount: '{$total}',
            locale: '{$smarty.const.DESCR_SL}',
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


    jQuery(document).ready(() => {

        function adjustPopupFontSize() {
            if (screen.width <= 500) {
                jQuery('div.paylike.overlay:not(.full-screen) div.payment').css('font-size', '1.5rem');
            } else if (screen.width <= 800) {
                jQuery('div.paylike.overlay:not(.full-screen) div.payment').css('font-size', '1rem');
            } else {
                jQuery('div.paylike.overlay:not(.full-screen) div.payment').css('font-size', '11px');
            }
        }
        
        adjustPopupFontSize();

        screen.orientation.addEventListener("change", (e) => {
            adjustPopupFontSize();
        });
        
        window.addEventListener("resize", (e) => {
            adjustPopupFontSize();
        });
    })

</script>
{/scripts}

</body>

</html>

