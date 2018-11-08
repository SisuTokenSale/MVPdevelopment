$(document).ready(function(){
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
    changeMonth: true,
    changeYear: true,
    maxDate: new Date
  }).mask('00/00/0000', {selectOnFocus: true});

  $('.ssn-mask').mask('000-00-0000', {selectOnFocus: true});
  $('.ssn-mask-num').mask('0000', {selectOnFocus: true});
});
