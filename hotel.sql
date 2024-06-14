PGDMP                         |            hotel    14.5    14.5 6    6           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            7           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            8           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            9           1262    75011    hotel    DATABASE     b   CREATE DATABASE hotel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';
    DROP DATABASE hotel;
                postgres    false                        3079    75107 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            :           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1255    75126    check_email_validity()    FUNCTION     u  CREATE FUNCTION public.check_email_validity() RETURNS TABLE(email character varying, is_valid boolean)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY
    SELECT
        email,
        CASE
            -- Проверка наличия недопустимых символов в адресе электронной почты
            WHEN email ~ '[^A-Za-z0-9@._-]' THEN FALSE
            -- Проверка на наличие символов, которые часто приводят к ошибкам
            WHEN email ~ '[\"<>\\'']' THEN FALSE
            -- Проверка формата адреса электронной почты
            WHEN email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$' THEN FALSE
            ELSE TRUE
        END
    FROM (
        SELECT DISTINCT email FROM GuestRegistration
    ) AS valid_emails;
END;
$_$;
 -   DROP FUNCTION public.check_email_validity();
       public          postgres    false            �            1255    75124 "   trg_update_service_price_history()    FUNCTION     %  CREATE FUNCTION public.trg_update_service_price_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO HistoryCost (change_date, service_id, old_price, new_price)
    VALUES (current_date, NEW.service_id, OLD.service_price, NEW.service_price);
    RETURN NEW;
END;
$$;
 9   DROP FUNCTION public.trg_update_service_price_history();
       public          postgres    false            �            1259    75118    employee    TABLE       CREATE TABLE public.employee (
    employee_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    full_name character varying(100) NOT NULL,
    date_of_birth date NOT NULL,
    phone_number character varying(20),
    address_city character varying(100),
    address_street character varying(100),
    address_house character varying(10),
    address_flat character varying(10)
);
    DROP TABLE public.employee;
       public         heap    postgres    false    2            �            1259    75034    guest    TABLE     �  CREATE TABLE public.guest (
    guest_id integer NOT NULL,
    last_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    patronymic character varying(100),
    date_of_birth date NOT NULL,
    passport_serial character varying(20),
    passport_number character varying(20),
    passport_issue_date date,
    passport_issued_by character varying(100),
    phone_number character varying(20),
    email character varying(100),
    address_city character varying(100),
    address_street character varying(100),
    address_house character varying(10),
    address_flat character varying(10),
    client character varying(30)
);
    DROP TABLE public.guest;
       public         heap    postgres    false            �            1259    75033    guest_guest_id_seq    SEQUENCE     �   CREATE SEQUENCE public.guest_guest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.guest_guest_id_seq;
       public          postgres    false    211            ;           0    0    guest_guest_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.guest_guest_id_seq OWNED BY public.guest.guest_id;
          public          postgres    false    210            �            1259    75096    historycost    TABLE     �   CREATE TABLE public.historycost (
    change_date date,
    service_id integer,
    old_price numeric(10,2),
    new_price numeric(10,2)
);
    DROP TABLE public.historycost;
       public         heap    postgres    false            �            1259    75062    registrationcard    TABLE     �   CREATE TABLE public.registrationcard (
    card_id integer NOT NULL,
    guest_id integer,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    room_number integer,
    payment_method character varying(50)
);
 $   DROP TABLE public.registrationcard;
       public         heap    postgres    false            �            1259    75061    registrationcard_card_id_seq    SEQUENCE     �   CREATE SEQUENCE public.registrationcard_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.registrationcard_card_id_seq;
       public          postgres    false    215            <           0    0    registrationcard_card_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.registrationcard_card_id_seq OWNED BY public.registrationcard.card_id;
          public          postgres    false    214            �            1259    75128    registrationcardservices    TABLE     �   CREATE TABLE public.registrationcardservices (
    card_service_id integer NOT NULL,
    card_id integer,
    service_id integer
);
 ,   DROP TABLE public.registrationcardservices;
       public         heap    postgres    false            �            1259    75127 ,   registrationcardservices_card_service_id_seq    SEQUENCE     �   CREATE SEQUENCE public.registrationcardservices_card_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.registrationcardservices_card_service_id_seq;
       public          postgres    false    221            =           0    0 ,   registrationcardservices_card_service_id_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.registrationcardservices_card_service_id_seq OWNED BY public.registrationcardservices.card_service_id;
          public          postgres    false    220            �            1259    75055    room    TABLE     �   CREATE TABLE public.room (
    room_number integer NOT NULL,
    room_class character varying(50) NOT NULL,
    price_per_night numeric(10,2) NOT NULL
);
    DROP TABLE public.room;
       public         heap    postgres    false            �            1259    75054    room_room_number_seq    SEQUENCE     �   CREATE SEQUENCE public.room_room_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.room_room_number_seq;
       public          postgres    false    213            >           0    0    room_room_number_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.room_room_number_seq OWNED BY public.room.room_number;
          public          postgres    false    212            �            1259    75084    service    TABLE     �   CREATE TABLE public.service (
    service_id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    service_price numeric(10,2) NOT NULL
);
    DROP TABLE public.service;
       public         heap    postgres    false            �            1259    75083    service_service_id_seq    SEQUENCE     �   CREATE SEQUENCE public.service_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.service_service_id_seq;
       public          postgres    false    217            ?           0    0    service_service_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.service_service_id_seq OWNED BY public.service.service_id;
          public          postgres    false    216            �           2604    75037    guest guest_id    DEFAULT     p   ALTER TABLE ONLY public.guest ALTER COLUMN guest_id SET DEFAULT nextval('public.guest_guest_id_seq'::regclass);
 =   ALTER TABLE public.guest ALTER COLUMN guest_id DROP DEFAULT;
       public          postgres    false    210    211    211            �           2604    75065    registrationcard card_id    DEFAULT     �   ALTER TABLE ONLY public.registrationcard ALTER COLUMN card_id SET DEFAULT nextval('public.registrationcard_card_id_seq'::regclass);
 G   ALTER TABLE public.registrationcard ALTER COLUMN card_id DROP DEFAULT;
       public          postgres    false    215    214    215            �           2604    75131 (   registrationcardservices card_service_id    DEFAULT     �   ALTER TABLE ONLY public.registrationcardservices ALTER COLUMN card_service_id SET DEFAULT nextval('public.registrationcardservices_card_service_id_seq'::regclass);
 W   ALTER TABLE public.registrationcardservices ALTER COLUMN card_service_id DROP DEFAULT;
       public          postgres    false    221    220    221            �           2604    75058    room room_number    DEFAULT     t   ALTER TABLE ONLY public.room ALTER COLUMN room_number SET DEFAULT nextval('public.room_room_number_seq'::regclass);
 ?   ALTER TABLE public.room ALTER COLUMN room_number DROP DEFAULT;
       public          postgres    false    213    212    213            �           2604    75087    service service_id    DEFAULT     x   ALTER TABLE ONLY public.service ALTER COLUMN service_id SET DEFAULT nextval('public.service_service_id_seq'::regclass);
 A   ALTER TABLE public.service ALTER COLUMN service_id DROP DEFAULT;
       public          postgres    false    216    217    217            1          0    75118    employee 
   TABLE DATA           �   COPY public.employee (employee_id, full_name, date_of_birth, phone_number, address_city, address_street, address_house, address_flat) FROM stdin;
    public          postgres    false    219   H       )          0    75034    guest 
   TABLE DATA           �   COPY public.guest (guest_id, last_name, first_name, patronymic, date_of_birth, passport_serial, passport_number, passport_issue_date, passport_issued_by, phone_number, email, address_city, address_street, address_house, address_flat, client) FROM stdin;
    public          postgres    false    211   
I       0          0    75096    historycost 
   TABLE DATA           T   COPY public.historycost (change_date, service_id, old_price, new_price) FROM stdin;
    public          postgres    false    218   �I       -          0    75062    registrationcard 
   TABLE DATA           y   COPY public.registrationcard (card_id, guest_id, check_in_date, check_out_date, room_number, payment_method) FROM stdin;
    public          postgres    false    215   ;J       3          0    75128    registrationcardservices 
   TABLE DATA           X   COPY public.registrationcardservices (card_service_id, card_id, service_id) FROM stdin;
    public          postgres    false    221   �J       +          0    75055    room 
   TABLE DATA           H   COPY public.room (room_number, room_class, price_per_night) FROM stdin;
    public          postgres    false    213   �J       /          0    75084    service 
   TABLE DATA           J   COPY public.service (service_id, service_name, service_price) FROM stdin;
    public          postgres    false    217   zK       @           0    0    guest_guest_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.guest_guest_id_seq', 2, true);
          public          postgres    false    210            A           0    0    registrationcard_card_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.registrationcard_card_id_seq', 4, true);
          public          postgres    false    214            B           0    0 ,   registrationcardservices_card_service_id_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.registrationcardservices_card_service_id_seq', 1, false);
          public          postgres    false    220            C           0    0    room_room_number_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.room_room_number_seq', 5, true);
          public          postgres    false    212            D           0    0    service_service_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.service_service_id_seq', 5, true);
          public          postgres    false    216            �           2606    75123    employee employee_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public            postgres    false    219            �           2606    75041    guest guest_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.guest
    ADD CONSTRAINT guest_pkey PRIMARY KEY (guest_id);
 :   ALTER TABLE ONLY public.guest DROP CONSTRAINT guest_pkey;
       public            postgres    false    211            �           2606    75067 &   registrationcard registrationcard_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.registrationcard
    ADD CONSTRAINT registrationcard_pkey PRIMARY KEY (card_id);
 P   ALTER TABLE ONLY public.registrationcard DROP CONSTRAINT registrationcard_pkey;
       public            postgres    false    215            �           2606    75133 6   registrationcardservices registrationcardservices_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.registrationcardservices
    ADD CONSTRAINT registrationcardservices_pkey PRIMARY KEY (card_service_id);
 `   ALTER TABLE ONLY public.registrationcardservices DROP CONSTRAINT registrationcardservices_pkey;
       public            postgres    false    221            �           2606    75060    room room_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_number);
 8   ALTER TABLE ONLY public.room DROP CONSTRAINT room_pkey;
       public            postgres    false    213            �           2606    75089    service service_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.service DROP CONSTRAINT service_pkey;
       public            postgres    false    217            �           2620    75125 $   service update_service_price_history    TRIGGER     �   CREATE TRIGGER update_service_price_history BEFORE UPDATE ON public.service FOR EACH ROW WHEN ((old.service_price <> new.service_price)) EXECUTE FUNCTION public.trg_update_service_price_history();
 =   DROP TRIGGER update_service_price_history ON public.service;
       public          postgres    false    217    232    217            �           2606    75068 /   registrationcard registrationcard_guest_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrationcard
    ADD CONSTRAINT registrationcard_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.guest(guest_id);
 Y   ALTER TABLE ONLY public.registrationcard DROP CONSTRAINT registrationcard_guest_id_fkey;
       public          postgres    false    211    215    3212            �           2606    75078 0   registrationcard registrationcard_guest_id_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrationcard
    ADD CONSTRAINT registrationcard_guest_id_fkey1 FOREIGN KEY (guest_id) REFERENCES public.guest(guest_id);
 Z   ALTER TABLE ONLY public.registrationcard DROP CONSTRAINT registrationcard_guest_id_fkey1;
       public          postgres    false    3212    211    215            �           2606    75073 2   registrationcard registrationcard_room_number_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrationcard
    ADD CONSTRAINT registrationcard_room_number_fkey FOREIGN KEY (room_number) REFERENCES public.room(room_number);
 \   ALTER TABLE ONLY public.registrationcard DROP CONSTRAINT registrationcard_room_number_fkey;
       public          postgres    false    215    213    3214            �           2606    75134 >   registrationcardservices registrationcardservices_card_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrationcardservices
    ADD CONSTRAINT registrationcardservices_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.registrationcard(card_id);
 h   ALTER TABLE ONLY public.registrationcardservices DROP CONSTRAINT registrationcardservices_card_id_fkey;
       public          postgres    false    3216    221    215            �           2606    75139 A   registrationcardservices registrationcardservices_service_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrationcardservices
    ADD CONSTRAINT registrationcardservices_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.service(service_id);
 k   ALTER TABLE ONLY public.registrationcardservices DROP CONSTRAINT registrationcardservices_service_id_fkey;
       public          postgres    false    217    3218    221            1   �   x�-�MN1�מS�9��]�d:��,`�
��ޠ-�M���� o�'?��Gv$LE[�q5ⰺ�H�$S��^�=��ŗ������+/R�l�,m�E ��C�n���:b"��?���c}�a��*�8�Q̥ČJSD�������x���MҾ��e���n��I�>y�:�\��%*���ؔ�q�;�\7�g�:��$~�w9�4���r��m�u�����      )   �   x�]����@��٧H/���j��>��H
�r˨��`k���������y�3F�1���?�~���G�q��w�VM�kW�X�U�W�x��-��@SsP�t�pXo�Za��m������E��9�gB��������*��F�<O4_���H`�\=�TD������_.�b��f���-�I�\x�>��#x"�/a��'��p&K��2N�����R��      0   3   x�3202�50"N 400�30�44�\F`I#]CSN#NS��D*F��� B
      -   �   x���1�0�W�Fg�&<��

D���(����q��Q��igג%'�	F~l G��	=��GF,�
w�V��n&���by��r�rD�Z�>�f�i&��3�gr3u�
���d?Е��[�'һ��w��3� GraK      3      x������ � �      +   r   x�5���0C��0�)��al��)�@E�3���R�!I/xc���NUUw����� s`�X�V��G��LP0c�B����v��R�({�y7ՅY�8�.JB�      /      x������ � �     