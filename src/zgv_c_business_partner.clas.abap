class ZGV_C_BUSINESS_PARTNER definition
  public
  final
  create public .

public section.

  interfaces ZGV_I_CRUD
      all methods final .

  aliases DELETE
    for ZGV_I_CRUD~DELETE .
  aliases INSERT
    for ZGV_I_CRUD~INSERT .
  aliases SELECT
    for ZGV_I_CRUD~SELECT .
  aliases UPDATE
    for ZGV_I_CRUD~UPDATE .

  data query_parameters type ZGV_T_BP .
  data:
    BUSINESS_PARTNERS type table of ZGV_T_BP .
  data adress type ZGV_T_ADRESS.

  methods CONSTRUCTOR
    importing
      value(NAME) type ZGV_DE_NAME optional
      value(LASTNAME) type ZGV_DE_LAST_NAME optional
      value(ID) type ZGV_DE_ID optional.

  methods SET_QUERY_PARAMETERS
    importing
      value(NAME) type ZGV_DE_NAME
      value(LASTNAME) type ZGV_DE_LAST_NAME
      value(ID) type ZGV_DE_ID
      value(ID_ADRESS) TYPE ZGV_DE_ID
      raising
      ZCX_EMPTY_QUERY_FIELDS .

  methods SET_ADRESS
  importing
   value(ID) type ZGV_DE_ID
   value(STREET) type ZGV_DE_STREET
   value(STREET_NUMBER) type ZGV_DE_STREET_NUMBER
   value(CITY) type ZGV_DE_CITY
   value(CITY_CODE) type ZGV_DE_CITY_CODE
   value(COUNTRY) type ZGV_DE_COUNTRY
   value(ID_BUSINESS_PARTNER) type ZGV_DE_ID
   value(FROM_TIME) type ZGV_DE_TIME
   value(FROM_DATE) type ZGV_DE_DATE
   raising ZCX_EMPTY_QUERY_FIELDS.

  methods ALL_BUSINESS_PARTNERS .

  methods TO_STRING .

  methods WRITE_ALL_BUSINESS_PARTNERS.

  methods CLEAR_DB_TABLE.

  PROTECTED SECTION.
private section.

  methods CHECK_query_parameters
    raising
      ZCX_EMPTY_QUERY_FIELDS .
ENDCLASS.


CLASS ZGV_C_BUSINESS_PARTNER IMPLEMENTATION.


  method ALL_BUSINESS_PARTNERS.
    clear business_partners.
    select * from ZGV_T_BP appending table business_partners.
  endmethod.

  method CLEAR_DB_TABLE.
    delete from ZGV_T_BP.
  ENDMETHOD.

  method CHECK_query_parameters.
    if query_parameters-ID = '' or query_parameters-NAME = ''
       or  query_parameters-LASTNAME = '' .
      raise exception type ZCX_EMPTY_QUERY_FIELDS.
    endif.
  endmethod.


  METHOD constructor.
    all_business_partners( ).
    query_parameters-id = id.
    query_parameters-lastname = lastname.
    query_parameters-name = name.
  ENDMETHOD.

  METHOD SET_ADRESS.

  if id = '' or street = '' or street_number = '' or city = '' or city_code = '' or country = '' or id_business_partner = '' or from_date = '' or from_time = ''.
    raise EXCEPTION type ZCX_EMPTY_QUERY_FIELDS.
  endif.

  adress-id = id.
  adress-street = street.
  adress-street_number = street_number.
  adress-city = city.
  adress-city_code = city_code.
  adress-country = country.
  adress-id_business_partner = id_business_partner.
  adress-from_date = from_date.
  adress-from_time = from_time.

  INSERT INTO ZGV_T_ADRESS VALUES adress.

  ENDMETHOD.

  method TO_STRING.
    data msg type string.
    concatenate 'Business partner id:' query_parameters-id
                'Fullname:' query_parameters-name query_parameters-lastname
    into msg separated by ' '.
    write msg.
  endmethod.

  method WRITE_ALL_BUSINESS_PARTNERS.
   DATA msg TYPE string VALUE ''.
    clear business_partners.
    SELECT * FROM ZGV_T_BP INTO TABLE business_partners.
    write  'All Business Partners: '. skip.
    concatenate 'ID' 'Name' 'Lastname' 'Adress ID' into msg separated by '      '.
    WRITE msg.
    CLEAR msg.
    LOOP AT business_partners ASSIGNING FIELD-SYMBOL(<fs>).
      SKIP.
      CONCATENATE <fs>-id <fs>-name <fs>-lastname <fs>-id_adress
        INTO msg SEPARATED BY '       ' .
      WRITE msg.
      CLEAR msg.
    ENDLOOP.
    skip.
  endmethod.


  METHOD SET_QUERY_PARAMETERS.

    query_parameters-id = id.
    query_parameters-lastname = lastname.
    query_parameters-name = name.
    query_parameters-id_adress = id_adress.

  ENDMETHOD.


  METHOD zgv_i_crud~delete.
    DATA msg TYPE string VALUE ''.
    if query_parameters-id = ''.
      raise exception type ZCX_EMPTY_QUERY_FIELDS.
    endif.
    DELETE FROM zgv_t_bp WHERE id = query_parameters-id.
    IF sy-subrc = 0.
      concatenate 'SUCESSFULY DELETED BUSINESS PARTNER WITH ID' query_parameters-id
      into msg SEPARATED BY ' '.
      CLEAR query_parameters.

    ELSE.
    msg = 'DELETION UNSUCESSFUL!'.
    ENDIF.
    WRITE msg.
  ENDMETHOD.


  METHOD zgv_i_crud~insert.

    check_query_parameters( ).

    INSERT INTO ZGV_T_BP VALUES query_parameters.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_duplicated_key.
    ENDIF.

  ENDMETHOD.


  METHOD zgv_i_crud~select.
    clear business_partners.

    if query_parameters-id <> ' '.
      select * from ZGV_T_BP appending table business_partners where id = query_parameters-id.
    else.
      select * from ZGV_T_BP appending table business_partners.
    endif.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_no_db_entry.
    ENDIF.

  ENDMETHOD.


  METHOD zgv_i_crud~update.
    check_query_parameters( ).

    UPDATE ZGV_T_BP FROM query_parameters.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_no_db_entry.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
