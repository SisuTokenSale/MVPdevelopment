$(document).ready(function(){
  $('.datepicker').datepicker({
    dateFormat: 'dd/mm/yy',
    yearRange: "-100:-18", // last hundred years
    maxDate: new Date,
    changeMonth: true,
    changeYear: true,
  }).mask('00/00/0000', {selectOnFocus: true});

  $('.ssn-mask').mask('000-00-0000', {selectOnFocus: true});
  $('.ssn-mask-num').mask('000-00-0000', {selectOnFocus: true});
});
