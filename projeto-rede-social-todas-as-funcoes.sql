﻿---------------------------------tabela usuario--------------------------------------------------------

----------------------------------------adicionar---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_usuario(email VARCHAR(100), 
senha VARCHAR(50), username VARCHAR(50)) RETURNS void AS $$

BEGIN
	INSERT INTO usuario VALUES (default, email, senha, username);
	RAISE NOTICE 'Usuario inserido com sucesso!';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_usuario(email VARCHAR(100), 
senha VARCHAR(50), username VARCHAR(50), telefone VARCHAR(20)) RETURNS void AS $$

BEGIN
	INSERT INTO usuario VALUES (default, email, senha, username, telefone);
	RAISE NOTICE 'Usuario inserido com sucesso!';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_usuario(email VARCHAR(100), 
senha VARCHAR(50), username VARCHAR(50), telefone VARCHAR(20),
nascimento date) RETURNS void AS $$

BEGIN
	INSERT INTO usuario VALUES (default, email, senha, username, telefone, nascimento);
	RAISE NOTICE 'Usuario inserido com sucesso!';
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------deletar-----------------------------------------------------
CREATE OR REPLACE FUNCTION del_usuario(email VARCHAR(100)) 
RETURNS void AS $$

BEGIN
	DELETE FROM usuario u where u.e_mail = email ;
	RAISE NOTICE 'Usuario removido com sucesso!';
END;
$$ LANGUAGE plpgsql;

select del_usuario('marcia@gmail.com')
select del_usuario('wildrimak@outlook.com')
---------------------------------------------------------------atualizar------------------------------------------------------

CREATE OR REPLACE FUNCTION upd_usuario(email_antigo varchar(100), email_novo varchar(100), 
senha_nova VARCHAR(50), username_novo varchar(50), telefone_novo varchar(20), nascimento_novo date) 
RETURNS void AS $$

BEGIN
	UPDATE usuario set e_mail = email_novo, senha = senha_nova, username = username_novo, 
	telefone = telefone_novo, nascimento = nascimento_novo where e_mail = email_antigo;
	RAISE NOTICE 'Suas informações foram atualizadas com sucesso!';
END;
$$ LANGUAGE plpgsql;


----------------------------------------------------------funcoes do usuario-------------------------------------------------

select * from usuario;

select add_usuario('dadydlucaslopes@gmail.com', 'huia21803', 'SkyEolLoko');
select add_usuario('davyson@gmail.com', 'nonofajanc403', 'supervegeta');
select add_usuario('agnaldo@gmail.com', 'asdvfqd345', 'superagnaldo');
select add_usuario('jorgelucas.com', 'kjhnkj10048', 'JL');
select add_usuario('marcia@gmail.com', '8710048', 'Marcia');
select add_usuario('johnleno@gmail.com', 'jmasoqw2', 'JonhLeno');
select add_usuario('eloisaleno@gmail.com', 'dfadfg2', 'EloisaLeno', '+1 10 901390181');
select add_usuario('lara_larissa@gmail.com', 'dfh9ahuig2', 'Lara Larissa', '+55 85 994001581', '2000-02-20');

select * from usuario;

select del_usuario('marcia@gmail.com');

select * from usuario;

select upd_usuario('jorge_lucas@gmail.com', 'jorge_lucas@gmail.com', 'bolsonaro2018', 'Jorge Lucas', '+55 88 99410 1021', '1997-07-20');
select upd_usuario('finalwildrimak@gmail.com', 'finalwildrimak@gmail.com', 'hauhahlilili', 'Super Wildrimak', '+55 86 9 9810-0097', '1997-07-12');
select upd_usuario('agnaldo@gmail.com', 'agnaldo@gmail.com', 'tutys1289', 'Super Agnaldo', null, '2004-02-15');

select * from usuario;

select * from grupo;

select * from participante_do_grupo;

create or replace function add_grupo(nome_do_grupo varchar(50), quem_criou_o_grupo varchar(50)) returns void as $$

begin
	insert into grupo values(default, nome_do_grupo, 'now', (select id_usuario from usuario where username = quem_criou_o_grupo));
	insert into participante_do_grupo values((select id_usuario from usuario where username = quem_criou_o_grupo), 
	(select id_grupo from grupo where nome = nome_do_grupo));
	
	raise notice 'grupo criado com sucesso!';
end;
$$ LANGUAGE plpgsql;

select add_grupo('novo', 'Super Wildrimak');

select * from grupo;
select * from participante_do_grupo;

select find_id_usuario_by_username('lara');
select find_id_grupo_by_nome('novo');

create or replace function upd_grupo(nome_antigo varchar(50), novo_nome_do_grupo varchar(50), membro_do_grupo varchar(50)) 
returns void as $$

begin
  
	update grupo set nome = novo_nome_do_grupo where nome = nome_antigo
	and id_grupo in (
		select grupo_id_grupo from participante_do_grupo 
		where grupo_id_grupo = (find_id_grupo_by_nome(nome_antigo)) 
		and usuario_participante = (find_id_usuario_by_username(membro_do_grupo))	
	);

	raise notice 'Nome do grupo alterado com sucesso';
end;
$$ LANGUAGE plpgsql;

select upd_grupo('Familia Chrono Trigger', 'Chrono Trigger', 'r66y');

select * from grupo;

select * from mensagem_do_grupo;

create or replace function del_grupo(nome_do_grupo varchar(50), criador_do_grupo varchar(50)) 
returns void as $$

begin

	delete from mensagem_do_grupo where participante_do_grupo_id_grupo = (find_id_grupo_by_nome(nome_do_grupo));
	delete from participante_do_grupo where grupo_id_grupo = (find_id_grupo_by_nome(nome_do_grupo));
	delete from grupo where nome = nome_do_grupo and usuario_criador_do_grupo = (find_id_usuario_by_username(criador_do_grupo));
	raise notice 'grupo deletado com sucesso!';

end;

$$ LANGUAGE plpgsql;

select del_grupo('As Meninas Super Poderosas', 'lara');

select * from grupo;
select * from usuario;

create or replace function find_id_usuario_by_username(nome_de_usuario varchar(50), out result int) 
as 'select usuario.id_usuario from usuario where username = nome_de_usuario'
language sql;

create or replace function find_id_grupo_by_nome(nome_do_grupo varchar(50), out result int) 
as 'select grupo.id_grupo from grupo where nome = nome_do_grupo'
language sql;

select find_id_grupo_by_nome('novo');
select find_id_usuario_by_username('lara');

select * from participante_do_grupo;

create or replace function add_participante_do_grupo(usuario varchar(50), qual_grupo varchar(50))
returns void as $$

begin

	insert into participante_do_grupo values (find_id_usuario_by_username(usuario), 
	find_id_grupo_by_nome(qual_grupo));
	raise notice 'Usuario inserido com sucesso!';
end;

$$ LANGUAGE plpgsql;

select add_participante_do_grupo('nadia', 'Novo');
select add_participante_do_grupo('lucca', 'Novo');
select add_participante_do_grupo('lara', 'Novo');


create or replace function del_participante_do_grupo(usuario varchar(50), grupo varchar(50))
returns void as $$

begin

	delete from mensagem_do_grupo where participante_do_grupo_id_grupo = (find_id_grupo_by_nome(grupo))
	and participante_do_grupo_usuario_participante = (find_id_usuario_by_username(usuario));
	delete from participante_do_grupo where grupo_id_grupo = (find_id_grupo_by_nome(grupo))
	and usuario_participante = (find_id_usuario_by_username(usuario));
	raise notice 'participante do grupo foi deletado com sucesso';
end;

$$ language plpgsql;

select del_participante_do_grupo('nadia', 'Novo');
select * from participante_do_grupo;


select * from mensagem_do_grupo;
select * from participante_do_grupo;
select * from grupo;
select * from usuario;
select find_id_grupo_by_nome('novo');
select find_id_usuario_by_username('lara');

create or replace function add_mensagem_do_grupo(usuario varchar(50), grupo varchar(50), 
texto varchar(30000)) returns void as $$

begin
	insert into mensagem_do_grupo values (default, find_id_usuario_by_username(usuario),
	find_id_grupo_by_nome(grupo), texto, 'now');
	raise notice 'mensagem enviada com sucesso!';
end;

$$ language plpgsql;

select add_mensagem_do_grupo('nadia', 'Novo', 'Oi meninas');
select add_mensagem_do_grupo('lucca', 'Novo', 'Oi Marle de novo com isso?');
select add_mensagem_do_grupo('lara', 'Novo', 'nossa...');

select * from mensagem_do_grupo;

create or replace function del_mensagem_do_grupo(usuario varchar(50), grupo varchar(50), texto_a_se_apagar varchar(30000))
returns void as $$

begin
	delete from mensagem_do_grupo 
	where participante_do_grupo_usuario_participante = (find_id_usuario_by_username(usuario))
	and participante_do_grupo_id_grupo = (find_id_grupo_by_nome(grupo))
	and texto = texto_a_se_apagar;
end;

$$ language plpgsql;

select del_mensagem_do_grupo('nadia', 'Novo', 'Oi meninas');