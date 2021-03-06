#' spec_sql_list_fields
#' @usage NULL
#' @format NULL
#' @keywords internal
spec_sql_list_fields <- list(
  list_fields_formals = function() {
    # <establish formals of described functions>
    expect_equal(names(formals(dbListFields)), c("conn", "name", "..."))
  },

  #' @return
  #' `dbListFields()`
  list_fields = function(ctx, con, table_name) {
    iris <- get_iris(ctx)
    dbWriteTable(con, table_name, iris)

    fields <- dbListFields(con, table_name)
    #' returns a character vector
    expect_is(fields, "character")
    #' that enumerates all fields
    #' in the table in the correct order.
    expect_identical(fields, names(iris))
  },
  #' This also works for temporary tables if supported by the database.
  list_fields_temporary = function(ctx, con, table_name) {
    if (isTRUE(ctx$tweaks$temporary_tables) && isTRUE(ctx$tweaks$list_temporary_tables)) {
      dbWriteTable(con, table_name, data.frame(a = 1L, b = 2L), temporary = TRUE)
      fields <- dbListFields(con, table_name)
      expect_equal(fields, c("a", "b"))

      #' The returned names are suitable for quoting with `dbQuoteIdentifier()`.
      expect_equal(dbQuoteIdentifier(con, fields), dbQuoteIdentifier(con, c("a", "b")))
    }
  },

  #' If the table does not exist, an error is raised.
  list_fields_wrong_table = function(con) {
    name <- "missing"

    expect_false(dbExistsTable(con, name))
    expect_error(dbListFields(con, name))
  },

  #' Invalid types for the `name` argument
  list_fields_invalid_type = function(con) {
    #' (e.g., `character` of length not equal to one,
    expect_error(dbListFields(con, character()))
    expect_error(dbListFields(con, letters))
    #' or numeric)
    expect_error(dbListFields(con, 1))
    #' lead to an error.
  },

  #' An error is also raised when calling this method for a closed
  list_fields_closed_connection = function(ctx, closed_con) {
    expect_error(dbListFields(closed_con, "test"))
  },

  #' or invalid connection.
  list_fields_invalid_connection = function(ctx, invalid_con) {
    expect_error(dbListFields(invalid_con, "test"))
  },

  #' @section Specification:
  #'
  #' The `name` argument can be
  #'
  #' - a string
  #' - the return value of [dbQuoteIdentifier()]
  list_fields_quoted = function(con, table_name) {
    dbWriteTable(con, table_name, data.frame(a = 1L, b = 2L))
    expect_identical(
      dbListFields(con, dbQuoteIdentifier(con, table_name)),
      c("a", "b")
    )
  },

  #' - a value from the `table` column from the return value of
  #'   [dbListObjects()] where `is_prefix` is `FALSE`
  list_fields_object = function(con, table_name) {
    dbWriteTable(con, table_name, data.frame(a = 1L, b = 2L))
    objects <- dbListObjects(con)
    expect_gt(nrow(objects), 0)
    expect_false(all(objects$is_prefix))
    expect_identical(
      dbListFields(con, objects$table[[1]]),
      dbListFields(con, dbQuoteIdentifier(con, objects$table[[1]]))
    )
  },

  #'
  #' A column named `row_names` is treated like any other column.
  list_fields_row_names = function(con, table_name) {
    dbWriteTable(con, table_name, data.frame(a = 1L, row_names = 2L))
    expect_identical(dbListFields(con, table_name), c("a", "row_names"))
  },
  #
  NULL
)
