interface ZGV_I_CRUD
  public .

  methods INSERT
    raising
      ZCX_DUPLICATED_KEY
      ZCX_EMPTY_QUERY_FIELDS.
  methods SELECT
    raising
      ZCX_NO_DB_ENTRY .
  methods DELETE
    raising
      ZCX_EMPTY_QUERY_FIELDS .
  methods UPDATE
    raising
      ZCX_NO_DB_ENTRY
      ZCX_EMPTY_QUERY_FIELDS .
endinterface.
