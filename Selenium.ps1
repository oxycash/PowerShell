$Driver = Start-SeFirefox 
Enter-SeUrl https://old.reddit.com/ -Driver $Driver
#$driver.FindElementByName("btn btn-default redBtn").Submit()
$driver.FindElementByName("user").SendKeys("oxycash")
$driver.FindElementByName("passwd").sendkeys("11061990")
$driver.FindElementByClassName("btn").submit()


# https://ironmansoftware.com/automated-web-testing-with-selenium-and-powershell/
#https://github.com/adamdriscoll/selenium-powershell
#https://tech.mavericksevmont.com/blog/powershell-selenium-automate-web-browser-interactions-part-i/
#https://github.com/adamdriscoll/selenium-powershell
#https://www.toolsqa.com/selenium-webdriver/find-element-selenium/