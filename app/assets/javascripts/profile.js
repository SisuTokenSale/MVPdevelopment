(function() {
  this.App || (this.App = {});

  App.profile = {
    dobEl: $('.js-profile-dob'),
    ssnEl: $('.js-profile-ssn'),
    btn: $('.js-profile-create-btn'),
    dobIsValid: false,
    ssnIsValid: false,

    dobListener: function(){
      App.profile.dobEl.datepicker({
        dateFormat: 'dd/mm/yy',
        yearRange: "-100:-18", // last hundred years
        maxDate: new Date,
        changeMonth: true,
        changeYear: true,
      }).mask('00/00/0000', {
        selectOnFocus: true,
        onComplete: function(){
          App.profile.dobIsValid = true;
          App.profile.setFormState();
        }
      }).on('keydown', function(event){
        event.preventDefault();
      });
    },

    isValid: function(){
      return App.profile.dobIsValid && App.profile.ssnIsValid;
    },

    setFormState: function(){
      App.profile.btn.prop('disabled', !App.profile.isValid());
    },

    ssnListener: function(){
      App.profile.ssnEl.mask('000-00-0000', {
        selectOnFocus: true,
        onComplete: function(){
          App.profile.ssnIsValid = true;
          App.profile.setFormState();
        }
      })
    },

    securityInfoListener: function(){
      App.profile.setFormState();
    },

    withSSNDOBModal: function(callback){
      let securityInfoModal = $('#security-info');
      securityInfoModal.modal('show');

      App.profile.securityInfoListener();

      $('form#js-profile-create-form').on('ajax:success', function(event) {
        securityInfoModal.modal('hide');
        callback();
      })
    },

    fetchStatus: function(){
      return $.get(`/users/profile/status.json`, {});
    }
  };
}).call(this);

$(document).ready(function(){
  App.profile.dobListener();
  App.profile.ssnListener();
});
