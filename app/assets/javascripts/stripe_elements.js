var styles = {
  base: {
    color: '#495057',
    fontSize: '16px',
    fontWeight: 400,
    lineHeight: 1.5,
    fontSmoothing: 'antialiased'
  }
};

var cardNumber = stripe_elements.create('cardNumber', { style: styles });
cardNumber.mount('[id^="stripe-cc-number"]');
cardNumber.addEventListener('change', function(event) {
  // if (event.error) {
  //   displayError.textContent = event.error.message;
  // } else {
  //   displayError.textContent = '';
  // }
});

var cardExpiry = stripe_elements.create('cardExpiry', { style: styles });
cardExpiry.mount('[id^="stripe-cc-expiration"]');
cardExpiry.addEventListener('change', function(event) {
  // if (event.error) {
  //   displayError.textContent = event.error.message;
  // } else {
  //   displayError.textContent = '';
  // }
});

var cardCvc = stripe_elements.create('cardCvc', { style: styles });
cardCvc.mount('[id^="stripe-cc-cvc"]');
cardCvc.addEventListener('change', function(event) {
  // if (event.error) {
  //   displayError.textContent = event.error.message;
  // } else {
  //   displayError.textContent = '';
  // }
});
