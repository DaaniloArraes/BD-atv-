Create database haloween;
use haloween;



CREATE TABLE tabela_usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada usuário, gerado automaticamente
    nome VARCHAR(100) NOT NULL,                -- Nome do usuário, campo obrigatório
    email VARCHAR(255) NOT NULL UNIQUE,        -- Email do usuário, campo obrigatório e único
    idade INT NOT NULL                         -- Idade do usuário, campo obrigatório
);

DELIMITER $$

CREATE PROCEDURE InsereUsuariosAleatorios()
BEGIN
    DECLARE i INT DEFAULT 0;
    
    -- Loop para inserir 10.000 registros
    WHILE i < 10000 DO
        -- Gere dados aleatórios para os campos
        SET @nome := CONCAT('Usuario', i);
        SET @email := CONCAT('usuario', i, '@exemplo.com');
        SET @idade := FLOOR(RAND() * 80) + 18;  -- Gera uma idade entre 18 e 97 anos
        
        -- Insira o novo registro na tabela de usuários
        INSERT INTO tabela_usuarios (nome, email, idade) VALUES (@nome, @email, @idade);
        -- Incrementa o contador
        SET i = i + 1;
    END WHILE;
END$$ 

-- Restaure o delimitador padrão
DELIMITER ;


call InsereUsuariosAleatorios();


select * from tabela_usuarios;