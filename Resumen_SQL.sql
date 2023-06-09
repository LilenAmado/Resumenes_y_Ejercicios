-- Esquema, una división lógica de la base de datos para organizar los objetos. 
-- https://www.postgresql.org/docs/12/functions.html
-- Type: https://www.postgresql.org/docs/current/datatype.html
"""
=
<
>
>=
<=
<> or !=

AND - OR - NOT

"""
-- Select 
    -- Muestra toda la tabla
    SELECT * -- No es la mejor práctica porque traes todo
    FROM customers

-- Columnas especificas al mostrar
    SELECT 
        companyname AS Compania
        , country AS Pais
        , [Address] AS Direccion
    FROM customers

-- Cálculo en la consulta
    SELECT 
        ProductName
        , UnitPrice
        , UnitPrice * 12 as ImpuestoIVA
    FROM Products

    SELECT
        OrderID
        , ProductID
        , UnitePrice
        , Quantity
        , Discount
        , (UnitePrice * Quantity) - (UnitePrice * Quantity * Discount) as Parcial
    FROM [Order Details]

-- Función Año en consulta
    SELECT
        CustomerID
        , OrderID  
        , OrderDate
        , YEAR(OrderDate) as Anio
    FROM [Order Details]

-- Distinct: Para sacar duplicados
    SELECT DISTINCT 
        Country
    FROM Customers
    ORDER BY Country

-- Función Case
    SELECT 
        ProductName
        , Category = 
            CASE CategoryID
                WHEN 1 THEN 'Bebidas'
                WHEN 2 THEN 'Lacteos'
                WHEN 3 THEN 'OTros'
                ELSE 'No se encuentra en venta'
            END -- AS Category
    FROM Products
    ORDER BY ProductName

-- COUNT: Devuelve el número de filas que coinciden con la condición especifica de la consulta. Devuelve el numero de filas totales dependiendo la condición. Función agregada.
    
    SELECT count(first_name) FROM customers
	
	SELECT 
        first_name, 
        COUNT(first_name) as "num names"
	FROM customer
	GROUP BY first_name

    SELECT DISTINCT 
        rating as "Clasificación"
        , count(title) as "Cant. Películas"
    FROM Film
    Group by rating -- Se usa el group by para agrupar por el conteo

-- WHERE: Condiciones
    SELECT 
        rating as Rating
        , count(*) as Num
    FROM film
    WHERE rating = 'R' or rating = 'NC-17'
    GROUP BY rating

-- ORDER BY: ASC DESC
    SELECT 
        store_id
        , first_name
        , last_name
    FROM customer
    ORDER BY store_id DESC, first_name ASC

-- LIMIT (TOP 10 - LIMIT 10)

    SELECT first_name 
    FROM customer
    ORDER BY first_name ASC
    LIMIT 10

    SELECT TOP 10 first_name 
    FROM customer

-- BETWEEN: Un operador para unir entre un rango de valores (NOT BETWEEN)
    SELECT * 
    FROM payment
    WHERE amount BETWEEN 7 and 9

    SELECT * 
    FROM payment
    WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15'
    ORDER BY amount ASC

-- IN: Condición que verifica si el valor esta incluido en una lista de varios valores (NOT IN)

    SELECT 
        amount
        , COUNT(amount) 
    FROM payment
    WHERE amount IN (0.99, 1.98, 1.99)
    GROUP BY amount

-- LIKE: distingue minusculas y mayusculas - ILIKE: No distingue, toma todas. (Todos los caracteres que le sigan: % Un solo caracter: _)
    SELECT first_name
    FROM customer
    WHERE first_name LIKE 'J%'

    SELECT first_name
    FROM customer
    WHERE first_name LIKE '_her%'

    SELECT first_name
    FROM customer
    WHERE first_name ILIKE '%er%'

-- GROUP BY:
    SELECT 
        company
        , division
        , SUM(sales) 
    FROM finance
    WHERE division IN ('Marketing')
    GROUP BY company, division
    ORDER BY SUM(sales)

    SELECT 
        DATE(payment_date)
        , SUM(amount)
    FROM payment
    GROUP BY DATE(payment_date)
    ORDER BY SUM(amount) DESC
    
-- HAVING: Permite filtrar luego del group by, por ejemplo la función agregada

    SELECT company, SUM(sales)
    FROM finance
    WHERE company != 'Google'
    GROUP BY company
    HAVING SUM(sales) > 1000

    SELECT store_id, COUNT(*)
    FROM customer
    GROUP BY store_id
    HAVING COUNT(*) > 300 


-- Funciones agregadas: Tomar multiples entradas y devolver una sola salida.
-- AVG(): Devuelve el valor promedio. Devuelve float.

    SELECT AVG(replacement_cost) 
    FROM film

-- MAX(): Devuelve el valor máximo.

    SELECT MAX(replacement_cost) 
    FROM film

-- MIN(): Devuelve el valor mínimo.

    SELECT MIN(replacement_cost) 
    FROM film

-- SUM(): Devuelve la sumatoria total. 

    SELECT SUM(replacement_cost) 
    FROM film

-- ROUND(): Redondear decimales.
    SELECT ROUND(AVG(replacement_cost), 2)
    FROM film

-- DATE(): Convierte fecha/hora en fecha

    SELECT DATE(payment_date)
    FROM payment

-- JOINS (Para unir las tablas deben contener un campo en común)

-- Inner Join (Uniones internas) Los datos en común.
         
                /*
                    Tablas a utilizar para ver campo en común:
                        SELECT TOP 10 FROM Customers
                        SELECT TOP 10 FROM Orders
                */

    -- Entre dos tablas
        SELECT 
            C.CustomerID
            , C.Companyname
            , C.[Address]
            , C.ContactName
            , C.City
            , O.OrderID
            , O.OrderDate
            , O.ShippedDate
            , O.ShippAddress
        FROM Customers AS C
        INNER JOIN Orders AS O
        ON C.CustomerID = O.CustomerID

    -- Entre más tablas
        SELECT 
            C.CustomerID
            , C.Companyname
            , C.[Address]
            , C.ContactName
            , C.City
            , O.OrderID
            , O.OrderDate
            , O.ShippedDate
            , O.ShippAddress
            , D.OrderID
            , D.Quantity
            , D.UnitePrice
            , P.ProductID
            , P.ProductName

        FROM Customers AS C

        INNER JOIN Orders AS O
        ON C.CustomerID = O.CustomerID

        INNER JOIN [Orders Details] AS D
        ON O.OrderID = D.OrderID

        INNER JOIN Products AS P 
        ON D.ProductID = P.ProductID

-- Full outer Joins (Ambas tablas enteras tengan o no datos en común)

    SELECT * 
    FROM customer
    FULL OUTER JOIN payment
    ON customer.customer_id = payment.customer_id

    WHERE customer.customer_id IS null 
    OR payment.payment_id IS null

-- Left Joins: Toda la tabla izq más lo común con tabla derecha. 

    SELECT * 
    FROM registrations
    LEFT JOIN logins
    ON registrations.name = logins.name

    WHERE logins.log_id IS null  

-- Right Joins: Toda la tabla derecha más lo común con tabla izq. 

    SELECT * 
    FROM tabla_A
    RIGHT JOIN tabla_B
    ON tabla_A.columna_comun = tabla_B.columna_comun

-- Union: Combina el conjunto de resultados de dos o más sentencias SELECT. Una tabla arriba de la otra.

    SELECT * FROM tabla_A
    UNION 
    SELECT * FROM tabla_B

-- Outer Join (Uniones externas)

-- Cross Join (Uniones cruzadas)

-- Selft Join (Union de tablas con sigo mismas): Utiles para comparar valores y columnas dentro de una misma tabla

    SELECT 
        f1.film_id, 
        f1.title, 
        f2.film_id, 
        f2.title, 
        f1.length
    FROM film AS f1
    INNER JOIN film AS f2
    ON f1.film_id != f2.film_id
    AND f1.length = f2.length
    WHERE f1.length = 117

-- Subconsultas/Subquery:

    SELECT 
        student, 
        grade
    FROM test_scores
    WHERE grade > (
        SELECT AVG(grade)
        FROM test_scores
    )

    ---------

    SELECT 
        student, 
        grade
    FROM test_scores
    WHERE student IN (
        SELECT student
        FROM honor_roll_table
    )

    ---------
    
    SELECT title, rental_rate
    FROM film
    WHERE rental_rate > (
        SELECT AVG(rental_rate)
        FROM film
    )

    ---------
    
    SELECT film_id, title
    FROM film
    WHERE film_id IN(
                    SELECT inventory.film_id
                    FROM rental
                    INNER JOIN inventory 
                    ON  inventory.inventory_id = rental.inventory_id
                    WHERE return_date
                    BETWEEN '2005-05-29' 
                    AND '2005-05-30'
                )
    ORDER BY title

-- Funciones de tiempo
'''
SHOW ALL 
SHOW TIMEZONE
'''

-- TIME: Contiene solo hora

-- DATE: Contiene solo fecha

-- TIMESTAMP: Contiene fecha y hora

-- TIMESTAMPTZ: Contiene fecha, hora, timezone

-- TIMEZONE:

-- NOW:

    SELECT NOW()

-- TIMEOFDAY:

    SELECT TIMEOFDAY() -- Te da con formato string

-- CURRENT_TIME:

    SELECT CURRENT_TIME()

-- CURRENT_DATE:

    SELECT CURRENT_DATE()

-- EXTRACT(): YEAR - MONTH - DAY - WEEK - QUARTER

    EXTRACT(YEAR FROM date_columna)

    SELECT EXTRACT(YEAR FROM payment_date)
    FROM payment

-- AGE():

    AGE(date_columna) -- la edad / antigüedad

    SELECT AGE(payment_date)
    FROM payment

-- TO_CHAR(): Convertir tipo de date a text -- Buscar formatos en internet dependiendo de lo que necesite 
-- https://www.postgresql.org/docs/12/functions-formatting.html

    TO_CHAR(date_columna, 'mm-dd-yyyy')

    SELECT TO_CHAR(payment_date, 'dd/MM/YYYY')
    FROM payment

-- Funciones matemáticas: https://www.postgresql.org/docs/12/functions-math.html

    SELECT 
        ROUND(
            rental_rate / replacement_cost,
            4
        ) * 100
    FROM film

-- Funciones String https://www.postgresql.org/docs/12/functions-string.html

-- LENGTH():

    SELECT LENGTH(first_name) 
    FROM customer

-- CONCATENAR:

    SELECT first_name || ' ' || last_name
    FROM customer

-- UPPER: Mayúsculas

    SELECT UPPER(first_name) 
    FROM customer

-- LEFT: 
    
    SELECT LEFT(first_name, 1) 
    FROM customer

-- Constraints: Restricciones
NOT NULL
UNIQUE(Column_list)
PRIMARY KEY(Column_list)
FOREIGN KEY(Column_list)
CHECK
EXCLUSION 

-- CREATE TABLE
    CREATE TABLE nombre_tabla(

        nombre_columna TIPO restricciones_que_tendra_la_columna,
        nombre_columna TIPO restricciones_que_tendra_la_columna,

        restricciones_que_tendra_la_tabla 
        restricciones_que_tendra_la_tabla

    ) INHERITS nombre_de_tabla_existente -- si tiene algun tipo de relación con otra tabla y pueda heredarla de una tabla existente.

    -- Sintaxis simple 
        CREATE TABLE nombre_tabla(

            nombre_columna TIPO restricciones_que_tendra_la_columna,
            nombre_columna TIPO restricciones_que_tendra_la_columna

        )

        CREATE TABLE players(
            player_id SERIAL PRIMARY KEY,
            age SMALLINT NOT NULL,
        )

    -- Tipo de datos SERIAL (para PK) para que sea clave única (ver tipo de SERIAL que existen en img)

    -- Pequeño ejemplo de Modelado de datos
        CREATE TABLE account(
            user_id SERIAL PRIMARY KEY,
            user_name VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(50) NOT NULL,
            email VARCHAR(255) UNIQUE NOT NULL,
            created_on TIMESTAMP NOT NULL,
            last_login TIMESTAMP
        )

        CREATE TABLE job(
            job_id SERIAL PRIMARY KEY,
            job_name VARCHAR(255) UNIQUE NOT NULL
        )

        CREATE TABLE account_job(
            user_id INTEGER REFERENCES account(user_id),
            job_id INTEGER REFERENCES job(job_id),
            hire_Date TIMESTAMP
        )

-- INSERT
    INSERT INTO account(user_name, password, email, created_on)
    VALUES
    ('Jose', 'password', 'jose@email.com', CURRENT_TIMESTAMP)

    INSERT INTO job(job_name)
    VALUES
    ('Astronaut')

    INSERT INTO job(job_name)
    VALUES
    ('President')

    INSERT INTO account_job(user_id, job_id, hire_date)
    VALUES (1, 1, CURRENT_TIMESTAMP)

-- UPDATE
    UPDATE account
    SET last_login = CURRENT_TIMESTAMP
    WHERE last_login IS NULL

    UPDATE account
    SET last_login = created_on
    WHERE user_name = 'Jose'

    -- Sintaxis de update (actualización) basada en otra tabla
        UPDATE account_job
        SET hire_date = account.created_on
        FROM account
        WHERE account_job.user_id = account.user_id

        UPDATE account
        SET last_login = CURRENT_TIMESTAMP
        WHERE user_id = 1
        RETURNING email, created_on, last_login

-- DELETE

    -- Borrar toda la tabla
        DELETE FROM Tabla

    -- Borrar con filtro
        DELETE FROM Tabla 
        WHERE row_id = 1

    -- Borrar basado en la presencia de otras tablas
        DELETE FROM tabla_A
        USING tabla_B
        WHERE tabla_A.id = tabla_B.id


    -- Ejemplo de insert y delete
        
        INSERT INTO job(job_name)
        VALUES('Cowboy')

        SELECT * FROM job

        DELETE FROM job
        WHERE job_name = 'Cowboy'
        RETURNING job_id, job_name

-- ALTER (alterar/modificar)
-- https://www.postgresql.org/docs/current/sql-altertable.html
    """
    Permite cambios en una estructura de tabla existente, como:
    - Agregar, eliminar o renombrar columnas
    - Cambiar el tipo de datos de una columna
    - Establecer valores PREDETERMINADOS para una columna
    - Agregar restricciones CHECK
    - Cambiar el nombre de la tabla
    """

    -- Adicionar columna
    ALTER TABLE nombre_tabla 
    ADD COLUMN nueva_columna TYPE

    -- Sacar columna
    ALTER TABLE nombre_tabla 
    DROP COLUMN nombre_columna TYPE 

    -- Alter Contraints (restricción)
    ALTER TABLE nombre_tabla
    ALTER COLUMN nombre_columna
    SET DEFAULT value
    / DROP DEFAULT
    / SET NOT NULL 
    / DROP NOT NULL
    / ADD CONSTRAINT contraint_name 

    -- Ejemplo
        CREATE TABLE INFORMATION(
        info_id SERIAL PRIMARY KEY,
        title VARCHAR(500) NOT NULL,
        person VARCHAR(50) NOT NULL UNIQUE
        )

        SELECT * FROM INFORMATION

        ALTER TABLE INFORMATION
        RENAME TO new_info -- Renombrar la tabla

        SELECT * FROM new_info

        ALTER TABLE new_info 
        RENAME COLUMN person TO people -- Renombrar la columna

        ALTER TABLE new_info 
        ALTER COLUMN people DROP NOT NULL -- Sacar NOT NULL / SET poner

        INSERT INTO new_info(title)
        VALUES ('Some new title')

-- DROP

    ALTER TABLE nombre_tabla
    DROP COLUMN nombre_columna

    -- Remove all dependencies 
    
    ALTER TABLE nombre_tabla
    DROP COLUMN nombre_columna CASCADE

    -- Por si no sabes si existe la columna y evitar el error
    
    ALTER TABLE nombre_tabla
    DROP COLUMN IF EXISTS nombre_columna

    -- Multiples columnas 
    ALTER TABLE nombre_tabla
    DROP COLUMN nombre_columna_1,
    DROP COLUMN nombre_columna_2

    -- Ejemplo:
        ALTER TABLE new_info
        DROP COLUMN people

        select * from new_info

        ALTER TABLE new_info
        ADD COLUMN people VARCHAR(50)

-- CHECK Constraint
    CREATE TABLE employees(
        emp_id SERIAL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        birthday DATE CHECK(birthdate > '1900-01-01'),
        hire_date DATE CHECK(hire_date > birthdate),
        salary INTEGER CHECK(salary > 0)
    )

-- CASE (condicional IF/ELSE)
    SELECT 
        customer_id, 
        CASE 
            WHEN (customer_id <= 100) THEN 'Premium'
            WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
            ELSE 'Normal'
        END AS customer_class
    FROM customer

    SELECT 
        customer_id, 
        CASE 
            WHEN 2 THEN 'Winner'
            WHEN 5 THEN 'Second place'
            ELSE 'Normal'
        END AS Raffle_results
    FROM customer

    SELECT 
        SUM(
            CASE rental_rate
                WHEN 0.99 THEN 1
                ELSE 0
            ELSE 
        ) AS number_of_bargains,
        SUM(
            CASE rental_rate
                WHEN 2.99 THEN 1
                ELSE 0
            ELSE 
        ) AS regular,
        SUM(
            CASE rental_rate
                WHEN 4.99 THEN 1
                ELSE 0
            ELSE 
        ) AS premium
    FROM film

-- COALESCE: Devuelve el primer argumento que no sea nulo
    -- COALESCE(arg_1, arg_2, arg_n,...)
    
    SELECT COALESCE(1, 2) -- 1
    SELECT COALESCE(NULL, 2, 3) -- 2

    -- Ejemplo
    SELECT 
        item, 
        (
            price - 
            COALESCE(Discount, 0)
        ) AS final
    FROM table

    SELECT COALESCE(descuento, 0) -- Usar como remplazo de null, cuando no encuentra valor a descuento, le pone 0. 
    
-- CAST
    SELECT CAST('5' AS INTEGER)
    SELECT '5'::INTEGER

    SELECT CAST(date AS TIMESTAMP)
    FROM table

    SELECT 
        CHAR_LENGTH(
            CAST(inventory_id AS VARCHAR)
        )
    FROM rental

-- NULLIF

    SELECT(
        SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END) / 
        NULLIF(
            SUM(CASE WHEN department = 'C' THEN 1 ELSE 0 END), 0
        ) -- Retorna null cuando no puede dividir por 0/error
    ) AS department_ratio
    FROM department

-- VIEWS
    -- CREAR 
    CREATE VIEW customer_info AS
        SELECT 
            first_name
            , last_name
            , address
        FROM 
            customer
        INNER JOIN	
            address
        ON
            customer.address_id = address.address_id

    SELECT * FROM customer_info
    
    -- Modificar
    CREATE OR REPLACE VIEW customer_info AS
        SELECT 
            first_name
            , last_name
            , address
			, district
			
        FROM 
            customer
        INNER JOIN	
            address
        ON
            customer.address_id = address.address_id
	
    -- DROP 
    DROP VIEW IF EXISTS customer_info

    -- Cambiar el nombre de la vista
    ALTER VIEW customer_info RENAME TO c_info

-- IMPORT AND EXPORT

-- Python