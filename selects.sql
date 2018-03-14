select * from status; /* I[ok] D[ok] -P*/
select * from contrata; /* I[] D[] */
select * from mensagem; /* I[ok] D[ok] */
select * from mensagem_do_grupo; /* I[ok] D[ok] */
select * from participante_do_grupo; /* I[ok] D[ok] */

select * from grupo; /* I[ok] U[ok] D[ok] */
select * from compra; /* I[] U[] D[] */
select * from servico; /* I[] U[] D[] */
select * from usuario; /* I[ok] U[ok] D[ok] -FR*/
select * from contato; /* I[ok] U[ok] D[ok] */
select * from produto; /* I[] U[] D[] */
select * from item_compra; /* I[] U[] D[] */
select * from loja_virtual; /* I[] U[] D[] */

