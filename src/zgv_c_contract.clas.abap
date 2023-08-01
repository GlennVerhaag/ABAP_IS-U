CLASS zgv_c_contract DEFINITION
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

  data contracts type standard table of zgv_t_c.
  data query_parameters type zgv_t_c.

  methods CONSTRUCTOR
    importing
      value(ID_TARIFF) type ZGV_DE_ID optional
      value(ID_CONTRACT_ACCOUNT) type ZGV_DE_ID optional
      value(ID) type ZGV_DE_ID optional .

  methods SET_QUERY_PARAMETERS
    importing
      value(ID_TARIFF) type ZGV_DE_ID
      value(ID_CONTRACT_ACCOUNT) type ZGV_DE_ID
      value(ID) type ZGV_DE_ID .

  methods ALL_CONTRACTS .

  methods TO_STRING .

  methods WRITE_ALL_CONTRACTS.

  methods CLEAR_DB_TABLE.

  methods check_query_parameters
  raising ZCX_EMPTY_QUERY_FIELDS.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zgv_c_contract IMPLEMENTATION.
method ALL_CONTRACTS.

    clear contracts.
    select * from ZGV_T_C appending table contracts.
  endmethod.

  method CLEAR_DB_TABLE.
    delete from ZGV_T_C.
  ENDMETHOD.

  method CHECK_QUERY_PARAMETERS.
    if query_parameters-ID = '' or query_parameters-id_tariff = ''
       or  query_parameters-id_contract_account = '' .
      raise exception type ZCX_EMPTY_QUERY_FIELDS.
    endif.
  endmethod.


  METHOD constructor.
    all_contracts( ).
    query_parameters-id = id.
    query_parameters-id_contract_account = id_contract_account.
    query_parameters-id_tariff = id_tariff.
  ENDMETHOD.


  method TO_STRING.
    data msg type string.
    concatenate 'Contract ID:' query_parameters-id
                'Contract Account ID:' query_parameters-id_contract_account
                'Tariff ID:' query_parameters-id_tariff
    into msg separated by ' '.
    write msg.
  endmethod.

  method WRITE_ALL_CONTRACTS.
   DATA msg TYPE string VALUE ''.

    write  'All Contracts: '.
    skip.
    concatenate 'Contract ID' 'Tariff ID' 'Contract Account ID'  into msg separated by ' | '.
    WRITE msg.
    CLEAR msg.
    LOOP AT contracts ASSIGNING FIELD-SYMBOL(<fs>).
      SKIP.
      CONCATENATE <fs>-id <fs>-id_tariff <fs>-id_contract_account
        INTO msg SEPARATED BY '                   ' .
      WRITE msg.
      CLEAR msg.
    ENDLOOP.
    skip.
  endmethod.


  METHOD SET_QUERY_PARAMETERS.

    query_parameters-id = id.
    query_parameters-id_contract_account = id_contract_account.
    query_parameters-id_tariff = id_tariff.

  ENDMETHOD.


  METHOD zgv_i_crud~delete.
    DATA msg TYPE string VALUE ''.
    if query_parameters-id = ''.
      raise exception type ZCX_EMPTY_QUERY_FIELDS.
    endif.
    DELETE FROM zgv_t_c WHERE id = query_parameters-id.
    IF sy-subrc = 0.
      concatenate 'SUCESSFULY DELETED CONTRACT WITH CONTRACT-ID' query_parameters-id
      into msg SEPARATED BY ' '.
      CLEAR query_parameters.

    ELSE.
    msg = 'DELETION UNSUCESSFUL!'.
    ENDIF.
    WRITE msg.
  ENDMETHOD.


  METHOD zgv_i_crud~insert.

    " check_query_parameters( ).

    INSERT INTO ZGV_T_C VALUES query_parameters.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ZCX_duplicated_key.
    ENDIF.

  ENDMETHOD.


  METHOD zgv_i_crud~select.
    clear contracts.

    if query_parameters-id <> ' '.
      select * from ZGV_T_C appending table contracts where id = query_parameters-id.
    else.
      select * from ZGV_T_C appending table contracts.
    endif.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ZCX_no_db_entry.
    ENDIF.

  ENDMETHOD.


  METHOD zgv_i_crud~update.
    check_query_parameters( ).

    UPDATE ZGV_T_C FROM query_parameters.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE ZCX_no_db_entry.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
