/**
 * FinanceGest - relatorios.js
 * Renderiza graficos de barras e pizza com Chart.js.
 */

'use strict';

document.addEventListener('DOMContentLoaded', function () {

  var meses    = Object.keys(MONTHLY_DATA);
  var receitas = meses.map(function (m) { return MONTHLY_DATA[m].receitas; });
  var despesas = meses.map(function (m) { return MONTHLY_DATA[m].despesas; });

  /* ── Grafico de barras: Receitas vs Despesas por mes ── */
  var ctxBar = document.getElementById('monthlyChart');
  if (ctxBar && meses.length > 0) {
    new Chart(ctxBar, {
      type: 'bar',
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Receitas',
            data: receitas,
            backgroundColor: 'rgba(5, 150, 105, .75)',
            borderRadius: 5
          },
          {
            label: 'Despesas',
            data: despesas,
            backgroundColor: 'rgba(220, 38, 38, .75)',
            borderRadius: 5
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: 'top' } },
        scales: {
          y: {
            ticks: {
              callback: function (v) {
                return 'R$ ' + Number(v).toLocaleString('pt-BR', { minimumFractionDigits: 0 });
              }
            }
          }
        }
      }
    });
  } else if (ctxBar) {
    ctxBar.parentElement.innerHTML = '<p style="color:#94a3b8;text-align:center;padding:3rem">Sem dados mensais ainda.</p>';
  }

  /* ── Grafico de pizza: distribuicao por categoria ── */
  var ctxPie = document.getElementById('categoryChart');
  var catKeys = Object.keys(CATS_DATA);

  if (ctxPie && catKeys.length > 0) {
    var cores = [
      '#4f46e5','#059669','#dc2626','#d97706','#0891b2',
      '#7c3aed','#db2777','#65a30d','#ea580c','#0284c7'
    ];

    new Chart(ctxPie, {
      type: 'doughnut',
      data: {
        labels: catKeys,
        datasets: [{
          data: catKeys.map(function (k) { return CATS_DATA[k]; }),
          backgroundColor: cores.slice(0, catKeys.length),
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'right' },
          tooltip: {
            callbacks: {
              label: function (ctx) {
                return ' R$ ' + Number(ctx.raw).toLocaleString('pt-BR', { minimumFractionDigits: 2 });
              }
            }
          }
        }
      }
    });
  } else if (ctxPie) {
    ctxPie.parentElement.innerHTML = '<p style="color:#94a3b8;text-align:center;padding:3rem">Sem transacoes registradas.</p>';
  }

});
