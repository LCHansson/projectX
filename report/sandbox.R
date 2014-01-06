require(reportTemplate)
require(format.tables)
render_report(file.path(getwd(), "report/report.md"), 
              config_file = file.path(getwd(), "report/report.yml"), 
              "report.pdf", 
              format = "pdf", 
              )
