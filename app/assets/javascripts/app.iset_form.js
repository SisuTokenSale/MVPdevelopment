(function() {
  this.App || (this.App = {});

  App.iset_form = {
    moneyInput: $('form#js-set-create .js-money_input'),

    lowestInput: $('form#js-set-create .js-lowest_input'),

    formChbxEl: function(){
      return $('form#js-set-create input[type=radio]');
    },

    getCheckedId: function(){
      return $('form#js-set-create input[type=radio]:checked').attr('id');
    },

    moneyInputEl: function(){
      return $('form#js-set-create .js-money_input');
    },

    lowestInputEl: function(){
      return $('form#js-set-create .js-lowest_input');
    },

    getState: function(){
      return App.state.iset_form;
    },

    setState: function(newState){
      return Object.assign(App.state.iset_form, newState);
    },

    applyListener: function(){
      App.iset_form.formChbxEl().on('click', function(e){
        App.iset_form.setState({ current: e.target.id })
        App.iset_form.show(e.target.id);
      })
    },

    init: function(){
      App.iset_form.moneyInput = App.iset_form.moneyInputEl().remove();
      App.iset_form.lowestInput = App.iset_form.lowestInputEl().remove();
      App.iset_form.show(App.iset_form.getCheckedId());
      App.iset_form.applyListener();
    },

    show: function(id){
      let moneyInput = App.iset_form.moneyInput.remove();
      let lowestInput = App.iset_form.lowestInput.remove();

      if(id === 'lowest'){
        moneyInput.hide();
        $('form#js-set-create [for=lowest] .form-input').append(lowestInput.show());
      } else if(id === 'algo'){
        lowestInput.hide();
        moneyInput.hide();
      } else {
        lowestInput.hide();
        $(`form#js-set-create [for=${id}] .form-input`).append(moneyInput.show());
      }
    }
  };
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  App.iset_form.init();
});
