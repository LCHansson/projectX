Generate report:

    library(reportTemplate)
    # setwd("projectX/report")
    render_report(
      file = "report.template",
      config_file = "config.yml",
      data = list(
        street = "Väringgatan",
        number = "1"
      ),
      clean = F
    )
