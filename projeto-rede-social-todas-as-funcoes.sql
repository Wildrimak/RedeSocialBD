create or replace function find_id_usuario_by_username(nome_de_usuario varchar(50), out result int)
as 'select usuario.id_usuario from usuario where username = nome_de_usuario'
language sql;

create or replace function find_id_grupo_by_nome(nome_do_grupo varchar(50), out result int)
as 'select grupo.id_grupo from grupo where nome = nome_do_grupo'
language sql;

create or replace function MudarValorDoIdParticipanteEmMensagemDoGrupoParaZeroAoRemoveLo() 
returns trigger as $$

begin

	update mensagem_do_grupo set participante_do_grupo_usuario_participante = 0 
	where participante_do_grupo_usuario_participante = old.usuario_participante 
	and participante_do_grupo_id_grupo = old.grupo_id_grupo;
	return old;

end; 
$$ language plpgsql;


create trigger MudarValorDoIdParticipanteEmMensagemDoGrupoParaZeroAoRemoveLo before delete on participante_do_grupo
for each row execute procedure MudarValorDoIdParticipanteEmMensagemDoGrupoParaZeroAoRemoveLo()

create or replace function adicionar(nome_da_tabela varchar(50), usuario_que_participa varchar(50), grupo varchar(50))
returns void as $$

begin
	if nome_da_tabela = 'participante_do_grupo' then
		insert into participante_do_grupo values (
		find_id_usuario_by_username(usuario_que_participa), 
		find_id_grupo_by_nome(grupo));
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, tente novamente.';
	
	end if;

end;
$$ language plpgsql;

select adicionar('participante_do_grupo', 'EloisaLeno', 'Associados a Wildrimak');


select * from participante_do_grupo; 
select * from usuario;
select * from grupo;

create or replace function adicionar(nome_da_tabela varchar(50), meu_contato varchar(50), outro_contato varchar(50), nomear_outro_contato varchar(50))
returns void as $$

begin

	if nome_da_tabela = 'contato' then
		insert into contato values (
			find_id_usuario_by_username(meu_contato),
			find_id_usuario_by_username(outro_contato),
			nomear_outro_contato
		);
	end if;

end;
$$ language plpgsql;

select adicionar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');
select adicionar('contato', 'Super Wildrimak', 'nadia', 'Marle');
select adicionar('contato', 'Super Wildrimak', 'fabricio', 'Fabricio');


select * from contato;
select * from usuario;


create or replace function alterar(nome_da_tabela varchar(50), meu_contato varchar(50), outro_contato varchar(50), novo_nome_do_contato varchar(50))
returns void as $$

begin

	if nome_da_tabela = 'contato' then

		update contato set nome = novo_nome_do_contato where eu = find_id_usuario_by_username(meu_contato)
		and ele = find_id_usuario_by_username(outro_contato);

		raise info 'Nome do contato alterado com sucesso!';
	else
		raise info 'Esta tabela ou contato não existe!';

	end if;

end;
$$ language plpgsql;

select * from contato;
select * from usuario;

select alterar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');


create or replace function deletar(nome_da_tabela varchar(50), meu_contato varchar(50), outro_contato varchar(50))
returns void as $$

begin

	if nome_da_tabela = 'contato' then

		delete from contato where eu = find_id_usuario_by_username(meu_contato)
		and ele = find_id_usuario_by_username(outro_contato);

		raise info 'Contato deletado com sucesso!';
	else
		raise info 'Esta tabela ou contato não existe!';

	end if;

end;
$$ language plpgsql;



select alterar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');


create or replace function deletar(nome_da_tabela varchar(50), meu_contato varchar(50), outro_contato varchar(50))
returns void as $$

begin

	if nome_da_tabela = 'contato' then

		delete from contato where eu = find_id_usuario_by_username(meu_contato)
		and ele = find_id_usuario_by_username(outro_contato);

		raise info 'Contato deletado com sucesso!';

	elsif nome_da_tabela = 'participante_do_grupo' then
		delete from participante_do_grupo 
		where usuario_participante = find_id_usuario_by_username(usuario_que_participa) 
		and grupo_grupo = find_id_grupo_by_nome(grupo);
		raise notice 'Participante adicionado com sucesso!';
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, tente novamente.';
	
	end if;	

end;
$$ language plpgsql;

select * from contato;
select * from usuario;

select * from participante_do_grupo;
select * from mensagem_do_grupo;

select adicionar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');
select deletar('contato', 'Super Wildrimak', 'supervegeta');

/*
begin
	IF TG_OP = 'INSERT' then

	ELSIF TG_OP 'DELETE' then

	TODA VEZ QUE UM GRUPO FOR CRIADO O USUARIO DELETADO DEVE SER INSERIDO AUTOMATICAMENTE
	TODA VEZ QUE ALGUEM MANDAR MENSAGEM NO GRUPO O USERNAME TEM QUE SER COLOCADO AUTOMATICAMENTE
end;
*/


select * from grupo;