#' Create a Boostrap 4 dashboard navbar
#'
#' Build an adminLTE3 dashboard navbar
#'
#' @param ... Any UI element between left and right Ui.
#' @param skin Navbar skin. "dark" or "light".
#' @param status Navbar status. "primary", "danger", "warning",
#' "success", "info", "white", "gray-light" and all other available colors. See
#' \link{getAdminLTEColors}.
#' @param border Whether to separate the navbar and body by a border. TRUE by default.
#' @param compact Whether items should be compacted. FALSE by default.
#' @param sidebarIcon Icon of the main sidebar toggle.
#' @param controlbarIcon Icon to toggle the controlbar (left).
#' @param leftUi Custom left Ui content. Any Ui element.
#' @param rightUi Custom right Ui content. Any Ui element.
#'
#' @author David Granjon, \email{dgranjon@@ymail.com}
#'
#' @export
bs4DashNavbar <- function(..., skin = "light", status = NULL, border = TRUE,
                          sidebarIcon = "bars", compact = FALSE, controlbarIcon = "th",
                          leftUi = NULL, rightUi = NULL) {
  
  navbarTag <- shiny::tags$nav(
    class = paste0(
      "main-header navbar navbar-expand navbar-", status,
      " navbar-", skin, if (isTRUE(border)) " border-bottom-0" else NULL,
      if (compact) " text-sm" else NULL
    ),
    
    # left sidebar elements
    shiny::tags$ul(
      class = "navbar-nav",
      
      # sidebar toggle (left)
      shiny::tags$li(
        class = "nav-item",
        shiny::tags$a(
          class = "nav-link",
          `data-widget` = "pushmenu",
          href = "#",
          shiny::icon(sidebarIcon)
        )
      ),
      leftUi
    ),
    
    # in between content
    ...,
    
    # right sidebar elements
    shiny::tags$ul(
      class = "navbar-nav ml-auto",
      rightUi,
      
      # controlbar toggle
      shiny::tags$li(
        class = "nav-item",
        shiny::tags$a(
          id = "controlbar-toggle",
          class = "nav-link",
          `data-widget` = "control-sidebar",
          href = "#",
          shiny::icon(controlbarIcon)
        )
      ) 
    )
  )
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$style(
          shiny::HTML(
            paste0(
              ".fa-", sidebarIcon, "{
                 color: #000;
              }
               .fa-", controlbarIcon, "{
                 color: #000;
               }
              "
            )
          )
        )
      )
    ),
    navbarTag
  )
  
}




#' Create a Boostrap 4 dashboard dropdown menu
#'
#' Build an adminLTE3 dashboard dropdown menu
#'
#' @param ... Slot for \link{bs4DropdownMenuItem}.
#' @param show Whether to start with the dropdown open. FALSE by default.
#' @param status Dropdown menu status. "primary", "success", "warning", "danger" or "info".
#' @param labelText Dropdown label text.
#' @param src Dropdown link to an external ressource.
#' @param menuIcon Fontawesome icon (default = "bell")
#' @param align Menu alignment (default = "right")
#' 
#' @examples
#' if(interactive()){
#'  library(shiny)
#'  library(bs4Dash)
#'  
#'  shiny::shinyApp(
#'    ui = bs4DashPage(
#'      navbar = bs4DashNavbar(
#'       rightUi = bs4DropdownMenu(
#'        show = TRUE,
#'        labelText = "!",
#'        status = "danger",
#'        src = "http://www.google.fr",
#'        bs4DropdownMenuItem(
#'         text = "message 1",
#'         date = "today"
#'        ),
#'        bs4DropdownMenuItem(
#'         text = "message 2",
#'         date = "yesterday"
#'        )
#'       )
#'      ),
#'      sidebar = bs4DashSidebar(),
#'      controlbar = bs4DashControlbar(),
#'      footer = bs4DashFooter(),
#'      title = "test",
#'      body = bs4DashBody()
#'    ),
#'    server = function(input, output) {}
#'  )
#' }
#' 
#' @author David Granjon, \email{dgranjon@@ymail.com}
#'
#' @export
bs4DropdownMenu <- function(..., show = FALSE, labelText = NULL, src = NULL,
                            status = c("primary", "warning", "danger", "info", "success"), 
                            menuIcon = "bell", align = "right") {
  
  status <- match.arg(status)
  items <- list(...)
  n_items <- length(items)
  # remove the divider from the last item
  #items[[n_items]][[2]] <- NULL
  
  labelText <- n_items
  
  dropdownMenuTag <- shiny::tags$li(
    class = if (isTRUE(show)) "nav-item dropdown show" else "nav-item dropdown",
    shiny::tags$a(
      class = "nav-link",
      `data-toggle` = "dropdown",
      href = "#",
      shiny::icon(menuIcon),
      shiny::tags$span(
        class = paste0("badge badge-", status, " navbar-badge"), 
        labelText
      )
    ),
    shiny::tags$div(
      class = if (isTRUE(show)) {
        sprintf("dropdown-menu dropdown-menu-lg dropdown-menu-%s show", align)
      } else {
        sprintf("dropdown-menu dropdown-menu-lg dropdown-menu-%s", align)
      },
      shiny::tags$span(
        class = "dropdown-item dropdown-header", 
        paste0(n_items, " Items")
      ),
      shiny::tags$div(class = "dropdown-divider"),
      ...,
      shiny::tags$a(
        class = "dropdown-item dropdown-footer",
        href = src,
        target = "_blank",
        "See more"
      )
    )
  )
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$style(
          shiny::HTML(
            sprintf(
              ".fa-%s {
                color: #000;
               }
              "
              , menuIcon)
          )
        )
      )
    ),
    dropdownMenuTag
  )
  
}




#' Create a Boostrap 4 dashboard dropdown menu item
#'
#' Build an adminLTE3 dashboard dropdown menu item
#'
#' @param text Item content.
#' @param date Item date.
#' @param icon Item icon.
#'
#' @author David Granjon, \email{dgranjon@@ymail.com}
#'
#' @export
bs4DropdownMenuItem <- function(text, date = NULL, icon = "info-circle") {
  
  dropdownItemTag <- shiny::tagList(
    shiny::tags$a(
      class = "dropdown-item",
      href = "#",
      shiny::icon(icon),
      text,
      shiny::tags$span(
        class = "float-right text-muted text-sm",
        date,
        shiny::tags$span(
          class = "time",
          shiny::icon(icon)
        )
      )
    ),
    shiny::tags$div(class = "dropdown-divider")
  )
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$style(
          shiny::HTML(
            paste0(
              ".fa-", icon, "{
                color: #000;
              }
              "
            )
          )
        )
      )
    ),
    dropdownItemTag
  )
  
  # shiny::tags$a(
  #   class = "dropdown-item",
  #   href = src, 
  #   shiny::tags$div(
  #     class  = "media",
  #     shiny::tags$div(
  #       class = "media-body",
  #       shiny::tags$h3(
  #         class = "dropdown-item-title",
  #         shiny::tags$i(
  #           class = paste0("fa fa-", icon, " mr-2")
  #         ),
  #         shiny::tags$span(
  #           class = "float-right text-sm text-danger",
  #           bs4Stars(grade = 1, color = "warning")
  #         )
  #       ),
  #       shiny::tags$p(class = "text-sm", text),
  #       shiny::tags$p(
  #         class = "text-sm text-muted",
  #         shiny::tags$i(class = "fa fa-clock-o mr-1"),
  #         date
  #       )
  #     )
  #   )
  # )
  
}





#' Create a Bootstrap 4 user profile.
#'
#' @param ... Body content.
#' @param name User name.
#' @param src User profile picture.
#' @param title A title.
#' @param subtitle A subtitle.
#' @param footer Footer is any.
#' @param status Ribbon status: "primary", "danger", "success", "warning", "info" and 
#' "secondary".
#' 
#' @examples
#' if (interactive()) {
#'  library(shiny)
#'  library(bs4Dash)
#'  
#'  shinyApp(
#'   ui = dashboardPage(
#'     navbar = dashboardHeader(
#'       rightUi = bs4UserMenu(
#'        name = "Divad Nojnarg", 
#'        status = "primary",
#'        src = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg", 
#'        title = "bs4Dash",
#'        subtitle = "Author", 
#'        footer = p("The footer", class = "text-center"),
#'        "This is the menu content."
#'       )
#'     ),
#'     sidebar = dashboardSidebar(),
#'     body = dashboardBody(),
#'     title = "bs4UserMenu"
#'   ),
#'   server = function(input, output) {}
#'  )
#' }
#' 
#' @export
bs4UserMenu <- function(..., name = NULL, src = NULL, title = NULL,
                        subtitle = NULL, footer = NULL,
                        status = c("primary", "danger", "success", "warning", "info", "secondary")) {
  
  status <- match.arg(status)
  
  shiny::tags$li(
    class = "nav-item dropdown user-menu",
    shiny::tags$a(
      href = "#",
      class = "nav-link dropdown-toggle",
      `data-toggle` = "dropdown",
      `aria-expanded` = "false",
      shiny::tags$img(
        src = src,
        class = "user-image img-circle elevation-2",
        alt = "User Image"),
      shiny::tags$span(class = "d-none d-md-inline", name)
    ),
    shiny::tags$ul(
      class = "dropdown-menu dropdown-menu-lg dropdown-menu-right",
      shiny::tags$li(
        class = paste0("user-header bg-", status),
        shiny::tags$img(
          src = src,
          class = "img-circle elevation-2",
          alt = "User Image"),
        shiny::tags$p(title, shiny::tags$small(subtitle))),
      shiny::tags$li(class = "user-body", ...),
      if(!is.null(footer)) shiny::tags$li(class = "user-footer", footer)
    )
  )
}