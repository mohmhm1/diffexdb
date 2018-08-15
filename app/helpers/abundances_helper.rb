module AbundancesHelper
def r_script
		r =  RinRuby.new # establishing a new RinRuby connection

  r.eval <<-EOF
  R.file_path = Rails.root.join("app", "assets","data.txt").to_s
  R.image_path = Rails.root.join("app", "assets","images", "a.png").to_s
  R.eval("mydata <- read.table('data.txt')")
  R.eval("png(filename=image_path)")
  R.eval("plot(mydata$V6)")
  R.eval("dev.off()")
 EOF
end
end
