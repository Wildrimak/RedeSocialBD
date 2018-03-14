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

create or replace function DeletarTodasOcorrenciasDeUsuarioAoExcluiLo()
returns trigger as $$ 

begin
	delete from contato where ele = old.id_usuario;

	delete from status where usuario_id_usuario = old.id_usuario;

	update mensagem set usuario_remetente = 0 
	where usuario_remetente = old.id_usuario;
	update mensagem set usuario_destinatario = 0 
	where usuario_destinatario = old.id_usuario;

	delete from participante_do_grupo where usuario_participante =
	old.id_usuario;

	update grupo set usuario_criador_do_grupo = 0 
	where usuario_criador_do_grupo = old.id_usuario;

	return old;
end; 
$$ language plpgsql;	

create trigger DeletarTodasOcorrenciasDeUsuarioAoExcluiLo before delete on usuario
for each row execute procedure DeletarTodasOcorrenciasDeUsuarioAoExcluiLo()


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
	

create or replace function adicionar(varchar(10000), varchar(50), varchar(50), varchar(30000))
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

	elsif nome_da_tabela = 'mensagem' then
		insert into mensagem values (default, string_1, 'now',
		find_id_usuario_by_username(string_2),
		find_id_usuario_by_username(string_3) );
	
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, 
		tente novamente!';
	
	end if;

end;
$$ language plpgsql;

	select adicionar('mensagem', 'Bom dia!', 'Super Wildrimak', 'supervegeta');
	select adicionar('mensagem', 'Bom noite!', 'supervegeta', 'Super Wildrimak');
	select adicionar('mensagem', 'Bom noite!', 'supervegeta', 'lara');
	select adicionar('mensagem', 'Bom noite!', 'lara', 'supervegeta');		
	select adicionar('status', 'O naruto em um dia qualquer', null , 'Super Wildrimak');
	/* '/home/wildrimak/Pictures/naruto.png' */
	select adicionar('status', 'Eu vou sair desta rede', null , 'lara');
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


create or replace function adicionar(varchar(50), varchar(100), varchar(50), varchar(50),
varchar(20), date) returns void as $$

declare
	nome_da_tabela alias for $1;
	e_mail alias for $2; 
	senha alias for $3;
	username alias for $4;
	telefone alias for $5;
	nascimento alias for $6;
	
begin
	if nome_da_tabela = 'usuario' then
		insert into usuario values (default, e_mail, senha, 
		username, telefone, nascimento);
	else
		raise notice 'Esta tabela não existe';
	end if;

end;
$$ language plpgsql;

select adicionar('usuario', 'mario@gmail.com', '1!*HY54', 'Mario', '', '1983-03-14');


create or replace function alterar(varchar(50), varchar(50), varchar(50), varchar(50))
returns void as $$

declare
	nome_da_tabela alias for $1;
	string_1 alias for $2;
	string_2 alias for $3;
	string_3 alias for $4;

begin
	/*Nome antigo, Nome novo, Criador do grupo*/
	if nome_da_tabela = 'grupo' then
		update grupo set nome = string_2
		where nome = string_1
		and usuario_criador_do_grupo = find_id_usuario_by_username(string_3);  
		raise notice 'Nome do grupo alterado com sucesso!';
	
	elsif nome_da_tabela = 'contato' then

		update contato set nome = string_3 
		where eu = find_id_usuario_by_username(string_1)
		and ele = find_id_usuario_by_username(string_2);

		raise info 'Nome do contato alterado com sucesso!';

	else
		raise info 'Esta tabela ou contato não existe!';

	end if;

end;
$$ language plpgsql;

	select alterar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson Douglas');
	select alterar('grupo', 'Novo', 'Floresta da Razão', 'Super Wildrimak');

create or replace function alterar(varchar(50), varchar(100), varchar(100), varchar(50),
varchar(50), varchar(50), varchar(20), date) returns void as $$

declare
	nome_da_tabela alias for $1;
	e_mail_antigo alias for $2;
	e_mail_novo alias for $3;
	senha_antiga alias for $4; 
	senha_nova alias for $5;
	username_novo alias for $6;
	telefone_novo alias for $7;
	nascimento_novo alias for $8;
	
begin
	if nome_da_tabela = 'usuario' then
		update usuario set e_mail = e_mail_novo, senha = senha_nova, 
		username = username_novo, telefone = telefone_novo, 
		nascimento = nascimento_novo
		where e_mail = e_mail_antigo and senha = senha_antiga; 
		raise notice 'Usuario alterado com sucesso!';
	else
		raise notice 'Esta tabela não existe';
	end if;

end;
$$ language plpgsql;

	select alterar('usuario', 'finalwildrimak@gmail.com', 'wildrimak@gmail.com',
	'hauhahlilili', 'kj81polç;1', 'Wildrimak', '+55 86 9 9810-0097', '1997-12-07');

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

	elsif nome_da_tabela = 'usuario' then
		delete from usuario where username = string_1
		and senha = string_2;
		raise notice 'Usuario deletado com sucesso';
		
	elsif nome_da_tabela = 'participante_do_grupo' then
		delete from participante_do_grupo 
		where usuario_participante = find_id_usuario_by_username(string_1) 
		and grupo_id_grupo = find_id_grupo_by_nome(string_2);
		raise notice 'Participante adicionado com sucesso!';

	elsif nome_da_tabela = 'status' then
		delete from status where mensagem = string_1 
		and usuario_id_usuario = find_id_usuario_by_username(string_2);

	elsif nome_da_tabela = 'grupo' then

		delete from mensagem_do_grupo where participante_do_grupo_id_grupo =
		find_id_grupo_by_nome(string_1); 		

		delete from participante_do_grupo where grupo_id_grupo = 
		find_id_grupo_by_nome(string_1);

		delete from grupo where nome = string_1 
		and usuario_criador_do_grupo = find_id_usuario_by_username(string_2);
		raise notice 'Grupo,  Participantes e Mensagens do Grupo apagados com sucesso';
	
	else
		raise notice 'Esta tabela não existe no banco de dados, nada inserido, tente novamente.';
	
	end if;	

end;
$$ language plpgsql;

	select adicionar('contato', 'Super Wildrimak', 'supervegeta', 'Davyson');
	select deletar('contato', 'Super Wildrimak', 'supervegeta');
	select adicionar('participante_do_grupo', 'welton', 'Novo');
	select deletar('participante_do_grupo', 'welton', 'Novo');
	select adicionar('status', 'O naruto em um dia qualquer', null , 'Super Wildrimak');
	select deletar('status', 'O naruto em um dia qualquer', 'Super Wildrimak');
	select deletar('grupo', 'Associados a Wildrimak', 'Super Wildrimak');
	select deletar('usuario', 'EloisaLeno', 'dfadfg2');
	select deletar('usuario', 'lara', '67%1');
		

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

------------------------------------relatorios-----------------------------------------

create or replace function ver_participacoes_do_usuario_em_um_grupo(usuario varchar(50)) 
returns table (username varchar(50), telefone varchar(20), nascimento date, 
nome varchar(50)) as $$
	
begin

	return query select u.username, u.telefone, u.nascimento, g.nome from usuario u 
	inner join participante_do_grupo pg 
	on u.id_usuario = pg.usuario_participante inner join grupo g
	on pg.grupo_id_grupo = g.id_grupo where u.username = usuario;  
	return;

end;
$$ language plpgsql;

select * from ver_participacoes_do_usuario_em_um_grupo('nadia');