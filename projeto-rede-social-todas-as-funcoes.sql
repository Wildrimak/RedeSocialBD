/*---------------------------------Funcões de Ajuda e Triggers------------------------------------*/
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

create or replace function AdicionarUsuarioDeletadoAoCriarGrupo() 
returns trigger as $$

begin

	insert into participante_do_grupo values (0, new.id_grupo);
	return new;

end; 
$$ language plpgsql;

create trigger AdicionarUsuarioDeletadoAoCriarGrupo after insert on grupo
for each row execute procedure AdicionarUsuarioDeletadoAoCriarGrupo()


/*-----------------------------Fim de Funcões de Ajuda e Triggers------------------------- ---------*/

/*---------------------------------Funcões de Adicionar e Tesselect * from grupo;tes------------------------------------*/

create or replace function adicionar(varchar(50), varchar(50), varchar(50))
returns void as $$

declare
	nome_da_tabela alias for $1;
	string_1 alias for $2;
	string_2 alias for $3;

begin
	if nome_da_tabela = 'participante_do_grupo' then
		insert into participante_do_grupo values (
		find_id_usuario_by_username(string_1), 
		find_id_grupo_by_nome(string_2));

	elsif nome_da_tabela = 'grupo' then
		insert into grupo values (
			default, string_1, 'now', find_id_usuario_by_username(string_2)
		);
		
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, tente novamente.';
	
	end if;

end;
$$ language plpgsql;

	select adicionar('participante_do_grupo', 'welton', 'Novo');
	select adicionar('grupo', 'HahahaHihihi', 'Super Wildrimak');
	

create or replace function adicionar(varchar(50), varchar(50), varchar(50), varchar(30000))
returns void as $$

declare
	nome_da_tabela alias for $1;
	string_1 alias for $2; /*Meu usuario ou Usuario do Grupo que manda mensagem*/
	string_2 alias for $3; /*Outra pessoa no qual mudo o nome ou Grupo no qual mando mensagem */
	string_3 alias for $4; /*Nome dado a pessoa do contato ou texto enviado tratar tamanho 30000 da string*/
	
begin

	if nome_da_tabela = 'contato' then
		insert into contato values (
			find_id_usuario_by_username(string_1),
			find_id_usuario_by_username(string_2),
			string_3
		);
	elsif nome_da_tabela = 'mensagem_do_grupo' then
		insert into mensagem_do_grupo values (default,
		find_id_usuario_by_username(string_1), 
		find_id_grupo_by_nome(string_2),
		string_3, 'now', string_1);

	elsif nome_da_tabela = 'status' then
		insert into status values (default, string_1, 'now', lo_import(string_2), 
		find_id_usuario_by_username(string_3));
		raise notice 'Status enviado com sucesso!';
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, 
		tente novamente!';
	
	end if;

end;
$$ language plpgsql;

	select adicionar('status', 'O naruto em um dia qualquer', 
		null , 'Super Wildrimak');
	select adicionar('status', 'O naruto em um dia qualquer', 
		'/home/wildrimak/Pictures/naruto.png' , 'Super Wildrimak');

	/* '/home/wildrimak/Pictures/naruto.png' */

	SELECT lo_export('/home/wildrimak/Pictures/naruto.png') 
	FROM status WHERE id_status = 4;
	
	select adicionar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');
	select adicionar('contato', 'Super Wildrimak', 'nadia', 'Marle');
	select adicionar('contato', 'Super Wildrimak', 'fabricio', 'Fabricio');
	select adicionar('contato', 'Super Wildrimak', 'r66y', 'Robo');
	select adicionar('mensagem_do_grupo', 'Super Wildrimak', 'Associados a Wildrimak', 
		'Eu sou um baita de um teste');

	select adicionar('mensagem_do_grupo', 'Super Wildrimak', 'Associados a Wildrimak', 
		'Oi gente meu nome é Wildrimak e eu criei esse grupo para passar informações importantes para vocês sobre jogos');
	select adicionar('mensagem_do_grupo', 'lara', 'Associados a Wildrimak', 'Que nome de grupo tosco kkkkkkkkkkkkk');
	select adicionar('mensagem_do_grupo', 'welton', 'Associados a Wildrimak', 'Pois é tinha que ser algo mais realista');
	select adicionar('mensagem_do_grupo', 'fabricio', 'Associados a Wildrimak', 'Vou nem dizer nada...');
	select adicionar('mensagem_do_grupo', 'nadia', 'Chrono Trigger', 'Oi gente!!!');
	select adicionar('mensagem_do_grupo', 'lucca', 'Chrono Trigger', 'Marle que porra é essa... kkkkkk');
	select adicionar('mensagem_do_grupo', 'r66y', 'Chrono Trigger', 'Eu gostei!');


create or replace function adicionar(varchar(50), varchar(200), imagem oid, varchar(50)) 
returns void as $$

declare
	nome_da_tabela alias for $1;
	mensagem alias for $2; 
	usuario alias for $4;
	
begin

	
	else
		raise notice 'Esta tabela não existe';
	end if;

end;
$$ language plpgsql;

create or replace function alterar(nome_da_tabela varchar(50), meu_contato varchar(50), 
outro_contato varchar(50), novo_nome_do_contato varchar(50))
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

	select alterar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');

create or replace function deletar(varchar(50), varchar(50), varchar(50))
returns void as $$

declare 
	nome_da_tabela alias for $1;
	string_1 alias for $2;
	string_2 alias for $3;

begin

	if nome_da_tabela = 'contato' then
		delete from contato where eu = find_id_usuario_by_username(string_1)
		and ele = find_id_usuario_by_username(string_2);
		raise info 'Contato deletado com sucesso!';

	elsif nome_da_tabela = 'participante_do_grupo' then
		delete from participante_do_grupo 
		where usuario_participante = find_id_usuario_by_username(string_1) 
		and grupo_id_grupo = find_id_grupo_by_nome(string_2);
		raise notice 'Participante adicionado com sucesso!';

	elsif nome_da_tabela = 'grupo' and usuario_criador_grupo = 
	find_id_usuario_by_username(string_2) then
		/*Nao pode deletar grupo enquanto nao houver apenas ele como usuario */
		/*Ao apagar destruir todas as mensagens contidas naquele grupo*/
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, tente novamente.';
	
	end if;	

end;
$$ language plpgsql;

	select adicionar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');
	select deletar('contato', 'Super Wildrimak', 'supervegeta');
	select adicionar('participante_do_grupo', 'welton', 'Novo');
	select deletar ('participante_do_grupo', 'welton', 'Novo');


create or replace function deletar(varchar(50), varchar(50), varchar(50), varchar(30000))
returns void as $$

declare 
	nome_da_tabela alias for $1;
	string_1 alias for $2;
	string_2 alias for $3;
	string_3 alias for $4;

begin

	if nome_da_tabela = 'mensagem_do_grupo' then
		delete from mensagem_do_grupo 
		where participante_do_grupo_usuario_participante = find_id_usuario_by_username(string_1)
		and participante_do_grupo_id_grupo = find_id_grupo_by_nome(string_2)
		and texto = string_3;		
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, tente novamente.';
	
	end if;	

end;
$$ language plpgsql;

	select deletar('mensagem_do_grupo', 'Super Wildrimak', 'Associados a Wildrimak', 
		'Eu sou um baita de um teste');
