create type paymentmethod_types as enum ('QIWI', 'Yandex.Money', 'Credit card', 'WebMoney');
create type transaction_types as enum('Sale', 'Purchase');
create type attributes as enum('Force', 'Intelligence', 'Agility');
create type rarities as enum('Common', 'Uncommon', 'Rare', 'Mythical', 'Legendary', 'Immortal', 'Arcana', 'Ancient');
-- create type thing_types as enum('Weapon', 'Head', 'Arms', 'Back', 'Shoulders', 'Animal', 'Quiver', 'Taunt');

create table trading_platform (
    platform_id serial primary key,
    platform_name varchar not null,
    things_border integer not null
);

create table avatar (
    avatar_id serial primary key,
    url varchar not null,   
    width integer,
    height integer
);

create table rating (
    rating_id serial primary key,
    rating_num integer not null check(rating_num > 0 and rating_num < 10000) default 1,
    transactions_num integer not null,
    time_decrease_const timestamp not null,
    offense_num integer not null
);

create table paymentmethod (
    payment_id serial primary key,
    credentials varchar not null,
    paymentmethod_name varchar(32) not null,
    paymentmethod_type paymentmethod_types not null
);

create table customer (
    customer_id serial primary key,
    avatar_id integer references avatar (avatar_id) on update cascade on delete cascade,
    rating_id integer references rating (rating_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update on delete cascade,
    customer_name varchar(32) not null,
    age integer not null check (age > 0 and age < 120),
    become_offline_time timestamp
);

create index hash_customer_id on customer using hash (customer_id);

create table thing (
    thing_id serial primary key,
    customer_id integer references customer (customer_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update on delete cascade,
    is_selling boolean default true;   
    rarity rarities not null,
    thing_name varchar(32) not null,
    price integer not null
);
create index hash_thing_id on thing using hash (thing_id);  
-- основные операции будут транзакции, где нужно будет находить пользователей и вещи по id, поэтому имеет смысл сделать hash  индексы для этих полей, тк они оптимальны 
--для операций равенства

create table bonus (
    bonus_id serial primary key,
    thing_id integer references thing (thing_id) on update cascade on delete cascade,
    rating_scale integer not null check(rating_scale > 0 and rating_scale < 10000)
);


create table character (
    character_id serial primary key,
    thing_id integer references thing (thing_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update on delete cascade,
    character_name varchar(32) not null,
    attribute attributes not null
);
create index hash_character_id on character using hash (character_id);

create table customer_paymentmethod (
    payment_id integer references paymentmethod (payment_id) on update cascade on delete cascade,
    customer_id integer references customer (customer_id) on update cascade on delete cascade,
    constraint customer_paymentmethod_pk primary key(customer_id, payment_id)
);

create table message (
    message_id serial primary key,
    sender_id integer references customer (customer_id) on update cascade on delete cascade,
    recipient_id integer references customer (customer_id) on update cascade on delete cascade,
    content varchar not null,
    send_time timestamp not null
);

create table transaction (
    transaction_id serial primary key,
    first_customer_id integer references customer (customer_id) on update cascade on delete cascade,
    sec_customer_id integer references customer (customer_id) on update cascade on delete cascade, 
    first_thing_id integer references thing (thing_id) on update cascade on delete cascade,
    sec_thing_id integer references thing (thing_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update on delete cascade,
    description varchar,
    transaction_type transaction_types not null
);


-- аватары
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922506.svg", 256, 256);
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg", 256, 256);
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg", 256, 256);
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg", 256, 256);
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg", 256, 256);
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg", 256, 256);
insert into avatar(url, width, height) values("https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg", 256, 256);
-- измени ссылки на фотки плз, у меня короткие не делаются почему-то
-- рейтинг
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(1, 9999,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(2, 9800,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(3, 9721,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(4, 9654,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(5, 9638,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(6, 9502,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(7, 9489,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
--способ оплаты
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12923094340', 'Sberbank', 'Credit card');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12924094340', 'Citybank', 'Credit card');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12456094340', 'QIWI',     'Credit card');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12325943440', 'Yandex.Money', 'Yandex.Money');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12765345640', 'Yandex.Money', 'Yandex.Money');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12945094340', 'Bitcoins', 'WebMoney');
--торговая площадка
insert into trading_platform(platform_name, things_border) values('Dota2', 60000);
insert into trading_platform(platform_name, things_border) values('CSGO', 62000);
insert into trading_platform(platform_name, things_border) values('CiberPunk', 63000);
insert into trading_platform(platform_name, things_border) values('PUBG', 32000);
--клиент
insert into customer(avatar_id , rating_id, platform_id, customer_name, age, become_offline_time) values(1, 1, 1, 'Lexa2010', 11,'2020-12-19 10:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, age, become_offline_time) values(2, 2, 1, 'DimasMashina', 13,'2020-12-19 11:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, age, become_offline_time) values(3, 4, 1, 'sixteen', 21,'2020-11-28 22:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, age, become_offline_time) values(4, 3, 1, 'vedroid', 15,'2020-12-18 19:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, age, become_offline_time) values(5, 5, 1, 'VladKrutisna2', 14,'2020-12-19 12:23:54' );
--шмотки
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Rippers Reel of the Crimson Witness', 7832);
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Mythical', 'Hunger ofthe Howling Wilds', 1011);
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Dragonclaw Hook', 63200);
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Bracers of Aeons of the Crimson Witness', 33400);
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Sylvan Vedette', 2400);
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Rippers Reel of the Crimson Witness', 7833);
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Armor of the Demon Trickster', 5600);  
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Mask of the Demon Trickster', 2000); 
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Roshan Hunter', 132900); 
insert into thing(platform_id , rarity, thing_name, price) values(1, 'Immortal', 'Mask of the Demon Trickster', 2000); 
--бонусы
insert into bonus(thing_id, rating_scale) values(1, 9500); 
-- персонажи 
insert into character(thing_id, platform_id, character_name, attribute) values(1, 1, 'Pudge', 'Forse'); 
insert into character(thing_id, platform_id, character_name, attribute) values(2, 1, 'Riki', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(3, 1, 'Pudge', 'Forse');
insert into character(thing_id, platform_id, character_name, attribute) values(4, 1, 'Faceless Viod', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(5, 1, 'Windranger', 'Intelligence');
insert into character(thing_id, platform_id, character_name, attribute) values(6, 1, 'Pudge', 'Forse');
insert into character(thing_id, platform_id, character_name, attribute) values(7, 1, 'Monkey King', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(8, 1, 'Monkey King', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(9, 1, 'Ursa', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(10, 1, 'Monkey King', 'Agility');
--способы оплаты клиента
insert into customer_paymentmethod(payment_id, customer_id) values(1,1);
insert into customer_paymentmethod(payment_id, customer_id) values(1,3);
insert into customer_paymentmethod(payment_id, customer_id) values(2,1);
insert into customer_paymentmethod(payment_id, customer_id) values(3,1);
insert into customer_paymentmethod(payment_id, customer_id) values(4,3);
insert into customer_paymentmethod(payment_id, customer_id) values(5,2);
insert into customer_paymentmethod(payment_id, customer_id) values(2,3);
-- сообщения 
insert into message(sender_id, recipient_id, content, send_time) values(1,2, 'Привет, как сам?','2020-12-19 10:23:54');
insert into message(sender_id, recipient_id, content, send_time) values(2,1, 'Ку, норм. А ты ?','2020-12-19 10:24:20');
insert into message(sender_id, recipient_id, content, send_time) values(1,2, 'Не хочешь снизить цену на своего крысюка? У тебя уже месяц никто не покупает','2020-12-19 10:25:54');
insert into message(sender_id, recipient_id, content, send_time) values(2,1, 'Не, у меня не горит, могу подождать','2020-12-19 10:26:54');
--транзакции
insert into message(first_customer_id , sec_customer_id , first_thing_id, sec_thing_id, platform_id, transaction_type  ) values(1, 2, 1, null, 1, 'Sale');

--Тригер который проверяет если превышено максимальное количество вещей то добавления не происходит
create trigger thing_border_prevent_trigger before insert on thing as
    begin
        declare @thingsNum INT;
        declare @thingsBorder INT;
        set @thingsNum = select count(*) from thing;
        set @thingsBorder = select things_border from trading_platform where platform_id = new.platform_id
        if @thingsNum > @thingsBorder then
          signal sqlstate '45000' set message_text = 'Превышено максимальное количество предметов на текущей площадке!';
        end if;
    end;

--Тригер подсчитывающий рейтинг на основе его атрибутов
create trigger rating_count_trigger before insert, update on rating as
    begin
      set new.rating_num = new.rating_num + (new.transactions_num * 10 - new.offense_num * 3);
    end;

--Тригер устанавливающий время отправки сообщения
create trigger message_time_trigger before insert on message as
    begin
      set new.send_time = CURRENT_TIMESTAMP;
    end;

--Тригер инкрементирующий атрибут транзакций рейтинга
create trigger transaction_trigger before insert on transaction as
    begin 
        declare @firstUserTransact INT;
        declare @firstUserRatingID INT;
        declare @secUserTransact INT;
        declare @secUserRatingID INT;
        
        set @firstUserRatingID = select rating_id from customer where customer_id = new.first_customer_id;
        set @secUserRatingID = select rating_id from customer where customer_id = new.sec_customer_id;

        set @firstUserTransact = select transactions_num from rating
                                        where rating_id = @firstUserRatingID;
        
        set @secUserTransact = select transactions_num from rating
                                        where rating_id = @secUserRatingID;
        update rating
            set transactions_num = (@firstUserTransact + 1)
        where rating_id = @firstUserRatingID;

        update rating
            set transactions_num = (@secUserTransact + 1)
        where rating_id = @secUserRatingID;
    end;

--Процедура осуществляющяя выход пользователя из онлайна
create procedure user_exit @customer_id integer as
    begin
      update customer
         set become_offline_time= CURRENT_TIMESTAMP
       where customer_id = @customer_id;
    end;

create index "customer_id_index" on customer using hash("customer_id");