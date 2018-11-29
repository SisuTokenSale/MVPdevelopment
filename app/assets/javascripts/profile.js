(function() {
  this.App || (this.App = {});

  App.profile = {
    dobEl: $('.js-profile-dob'),
    ssnEl: $('.js-profile-ssn'),
    btn: $('.js-profile-create-btn'),
    dobIsValid: false,
    ssnIsValid: false,
    dobRegexp: /^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$/i,

    dobListener: function(){
      App.profile.dobEl.datepicker({
        dateFormat: 'dd/mm/yy',
        yearRange: "-100:-18", // last hundred years
        maxDate: new Date,
        changeMonth: true,
        changeYear: true,
      }).mask('00/00/0000', {
        selectOnFocus: true
      }).on('keydown', function(event){
        event.preventDefault();
      }).on('change', function(e){
        App.profile.dobIsValid = App.profile.dobRegexp.test($(e.target).val())
        App.profile.setFormState();
      });
    },

    isValid: function(){
      return App.profile.dobIsValid && App.profile.ssnIsValid;
    },

    setFormState: function(){
      App.profile.btn.prop('disabled', !App.profile.isValid());
    },

    ssnListener: function(){
      App.profile.ssnEl.mask('0000', {
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
