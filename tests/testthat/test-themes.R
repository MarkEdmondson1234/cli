
context("cli themes")

setup(start_app())
teardown(stop_app())

test_that("add/remove/list themes", {
  id <- default_app()$add_theme(list(".green" = list(color = "green")))
  on.exit(default_app()$remove_theme(id), add = TRUE)
  expect_true(id %in% names(default_app()$list_themes()))

  withr::with_options(list(cli.num_colors = 256L), {
    capt0(cli_par(class = "green"))
    out <- capt0(cli_text(lorem_ipsum()))
    capt0(cli_end())
    expect_true(grepl(
      attr(make_ansi_style("green"), "_styles")[[1]]$open,
      out,
      fixed = TRUE
    ))
  })

  default_app()$remove_theme(id)
  expect_false(id %in% names(default_app()$list_themes()))
})

test_that("default theme is valid", {
  expect_error({
    id <- default_app()$add_theme(builtin_theme())
    default_app()$remove_theme(id)
  }, NA)
})

test_that("explicit formatter is used, and combined", {
  id <- default_app()$add_theme(list(
    "span.emph" = list(
      fmt = function(x) paste0("(((", x, ")))"),
      before = "<<", after = ">>")
    ))
  on.exit(default_app()$remove_theme(id), add = TRUE)
  out <- capt0(cli_text("this is {.emph it}, really"))
  expect_match(ansi_strip(out), "(((<<it>>)))", fixed = TRUE)
})

test_that("simple theme", {
  def <- simple_theme()
  expect_true(is.list(def))
  expect_false(is.null(names(def)))
  expect_true(all(names(def) != ""))
  expect_true(all(vlapply(def, is.list)))
})

test_that("user's override", {
  custom <- list(".alert" = list(before = "custom:"))
  override <- list(".alert" = list(after = "override:"))

  start_app(theme = custom, .auto_close = FALSE)
  out <- capt0(cli_alert("Alert!"))
  expect_match(out, "custom:")
  stop_app()

  withr::with_options(list(cli.user_theme = override), {
    start_app(theme = custom, .auto_close = FALSE)
    out <- capt0(cli_alert("Alert!"))
    expect_match(out, "override:")
    stop_app()
  })
})

test_that("theme does not precompute Unicode symbols", {
  withr::local_options(cli.unicode = TRUE, cli.num_colors = 256L)
  start_app()
  msg <- NULL
  withCallingHandlers(
    cli_alert_success("ok"),
    cliMessage = function(m) msg <<- m
  )
  expect_true(ansi_has_any(msg$message))

  msg2 <- NULL
  withr::local_options(cli.unicode = FALSE, cli.num_colors = 1L)
  withCallingHandlers(
    cli_alert_success("ok2"),
    cliMessage = function(m) msg2 <<- m
  )
  expect_equal(msg2$message, "v ok2\n")
})
