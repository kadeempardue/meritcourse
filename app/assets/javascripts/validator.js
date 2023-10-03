$(document).ready(function() {
  document.addEventListener('DOMContentLoaded', function(e) {
    FormValidation.formValidation(
        $('.validate.form'),
        {
            fields: {
              first_name: {
                validators: {
                    notEmpty: {
                        message: 'First name is required'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: 'First name must be more than 6 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9_]+$/,
                        message: 'First name can only consist of alphabetical, number and underscore'
                    }
                }
              },
              last_name: {
                validators: {
                    notEmpty: {
                        message: 'Last name is required'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: 'Last name must be more than 6 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9_]+$/,
                        message: 'Last name can only consist of alphabetical, number and underscore'
                    }
                }
              },
              email: {
                validators: {
                    notEmpty: {
                        message: 'Email Address is required'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: 'Email Address must be more than 6 and less than 30 characters long'
                    },
                    emailAddress: {
                        message: 'The value is not a valid email address'
                    }
                }
              },
              password: {
                validators: {
                    notEmpty: {
                        message: 'Password is required'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: 'Password must be more than 6 and less than 30 characters long'
                    }
                }
              }
            },
            plugins: {
                uikit: new FormValidation.plugins.Uikit(),
            },
        }
    );
  });
});
