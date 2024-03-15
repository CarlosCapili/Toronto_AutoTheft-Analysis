import matplotlib.pyplot as plt
import pandas as pd

# Order the months for each year (Jan, Feb, Mar, etc.) and find corresponding number of thefts that month
def order_months(year):
    thefts = []
    for month in months:
        # Find index of month
        row_num = year.loc[year["report_month"]==month].index[0]
        # Take theft_per_month value and append to thefts list
        thefts.append(year.loc[row_num, "theft_per_month"])
    return thefts

# Add labels on points for graphs
def addlabels(x,y):
    for i in range(len(x)):
        plt.text(i,y[i],y[i])
    
if __name__ == "__main__":
    location = r"TheftPerMonth_PerYear.csv"
    monthly_thefts = pd.read_csv(location)

    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    years = ["2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023"]

    # Extract the data by year 
    thefts_by_year = []
    for row in range(0, len(monthly_thefts), 12):
        year = monthly_thefts.iloc[row:row+12]
        thefts_by_year.append(order_months(year))
        
    # Plot for each year
    for i in range(len(thefts_by_year)):
        plot_title = years[i] + " Auto Thefts Per Month"
        f = plt.figure()
        f.set_figwidth(9)
        f.set_figheight(5)

        plt.plot(months, thefts_by_year[i], '-o')
        addlabels(months, thefts_by_year[i])
        plt.xticks(rotation=45)
        plt.title(plot_title)
        plt.xlabel("Month")
        plt.ylabel("Auto Thefts")
        plt.show()

