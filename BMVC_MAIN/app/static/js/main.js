/**
 * FinanceGest - main.js
 * Utilitarios globais, inicializacao de formularios.
 * Carregado em todas as paginas.
 */

'use strict';

document.addEventListener('DOMContentLoaded', function () {

  // Preenche data atual nos inputs de data sem valor
  var dateInputs = document.querySelectorAll('input[type="date"]');
  var today = new Date().toISOString().split('T')[0];
  dateInputs.forEach(function (el) {
    if (!el.value) el.value = today;
  });

  // Alertas fecham ao clicar
  document.querySelectorAll('.alert').forEach(function (el) {
    el.style.cursor = 'pointer';
    el.title = 'Clique para fechar';
    el.addEventListener('click', function () {
      el.style.transition = 'opacity .3s';
      el.style.opacity = '0';
      setTimeout(function () { el.remove(); }, 300);
    });
  });

});

/** Formata numero como moeda brasileira */
function formatBRL(val) {
  return 'R$ ' + Math.abs(Number(val)).toLocaleString('pt-BR', {
    minimumFractionDigits: 2, maximumFractionDigits: 2
  });
}
