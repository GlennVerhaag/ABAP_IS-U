CLASS zgv_c_contract_account DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

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

  data contract_accounts type standard table of zgv_t_ca.
  data query_parameters type zgv_t_ca.

  methods CONSTRUCTOR
    importing
      value(ID_BUSINESS_PARTNER) type ZGV_DE_ID optional
      value(PAYMENT_CARD) type ZGV_DE_PAYMENT_CARD optional
      value(ID) type ZGV_DE_ID optional .

  methods SET_QUERY_PARAMETERS
    importing
      value(ID_BUSINESS_PARTNER) type ZGV_DE_ID optional
      value(PAYMENT_CARD) type ZGV_DE_PAYMENT_CARD optional
      value(ID) type ZGV_DE_ID
      raising ZCX_EMPTY_QUERY_FIELDS. .

  methods ALL_CONTRACT_ACCOUNTS .

  methods TO_STRING .

  methods WRITE_ALL_CONTRACT_ACCOUNTS.

  methods CLEAR_DB_TABLE.

  methods check_query_parameters
  raising ZCX_EMPTY_QUERY_FIELDS.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zgv_c_contract_account IMPLEMENTATION.
method ALL_CONTRACT_ACCOUNTS.

    clear contract_accounts.
    select * from ZGV_T_CA appending table contract_accounts.
  endmethod.

  method CLEAR_DB_TABLE.
    delete from ZGV_T_CA.
  ENDMETHOD.

  method CHECK_QUERY_PARAMETERS.
    if query_parameters-ID = '' or query_parameters-id_business_partner = ''
       or  query_parameters-payment_card = '' .
      raise exception type ZCX_EMPTY_QUERY_FIELDS.
    endif.
  endmethod.


  METHOD constructor.
    all_contract_accounts( ).
    query_parameters-id = id.
    query_parameters-id_business_partner = id_business_partner.
    query_parameters-payment_card = payment_card.
  ENDMETHOD.


  method TO_STRING.
    data msg type string.
    concatenate 'Contract Account ID:' query_parameters-id
                'Business Partner ID:' query_parameters-id_business_partner
    into msg separated by ' '.
    write msg.
    write 'Payment Card:' && query_parameters-payment_card.
  endmethod.

  method WRITE_ALL_CONTRACT_ACCOUNTS.
   DATA msg TYPE string VALUE ''.

    write  'All Contract Accounts: '.
    skip.
    concatenate 'Contract Account ID' 'Business Partner ID' 'Payment Card'  into msg separated by ' | '.
    WRITE msg.
    CLEAR msg.
    LOOP AT contract_accounts ASSIGNING FIELD-SYMBOL(<fs>).
      SKIP.
      CONCATENATE <fs>-id <fs>-id_business_partner
        INTO msg SEPARATED BY '                       ' .
      WRITE msg.
      WRITE '     '.
      WRITE <fs>-payment_card.
      CLEAR msg.
    ENDLOOP.
    skip.
  endmethod.


  METHOD SET_QUERY_PARAMETERS.

    query_parameters-id = id.
    query_parameters-id_business_partner = id_business_partner.
    query_parameters-payment_card = payment_card.

  ENDMETHOD.


  METHOD zgv_i_crud~delete.
    DATA msg TYPE string VALUE ''.
    if query_parameters-id = ''.
      raise exception type ZCX_EMPTY_QUERY_FIELDS.
    endif.
    DELETE FROM zgv_t_ca WHERE id = query_parameters-id.
    IF sy-subrc = 0.
      concatenate 'SUCESSFULY DELETED CONTRACT ACCOUNT WITH CONTRACT ACCOUNT ID' query_parameters-id
      into msg SEPARATED BY ' '.
      CLEAR query_parameters.

    ELSE.
    msg = 'DELETION UNSUCESSFUL!'.
    ENDIF.
    WRITE msg.
  ENDMETHOD.


  METHOD zgv_i_crud~insert.

    check_query_parameters( ).

    INSERT INTO ZGV_T_CA VALUES query_parameters.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ZCX_duplicated_key.
    ENDIF.

  ENDMETHOD.


  METHOD zgv_i_crud~select.
    clear contract_accounts.

    if query_parameters-id <> ' '.
      select * from ZGV_T_CA appending table contract_accounts where id = query_parameters-id.
    else.
      select * from ZGV_T_CA appending table contract_accounts.
    endif.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ZCX_no_db_entry.
    ENDIF.

  ENDMETHOD.


  METHOD zgv_i_crud~update.
    check_query_parameters( ).

    UPDATE ZGV_T_CA FROM query_parameters.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ZCX_no_db_entry.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
