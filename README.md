# eMarkt
- Online shop application made using Swift

## 1. Introduction  
  The application represents an online shopping application and was designed to present a solution that allows users to search, add to cart and buy different items presented by the seller.  
  The items are contained inside different categories, and each item can provide photos, the name, the price and the description of the product.  
  The user can browse items without being logged in, but when an item is added to cart, a login/register view is presented to the user. After loggin in/signing up, the user can add items to their cart and, after checkout, the items can be seen inside their shopping history.
  
  
## 2. Describing the functionalities
  The functionalities of the applications are: register and login to create a shopping cart and to checkout, searching items by a term from either name or description, adding a new item and editing the fields that describe a user: first name, last name and address.
  
  ## DEMO
  
## 3. Implementation
  The application uses Swift, Firebase for storage and Algolia for allowing the user to search for items.  
  The application also implements different Pods, such as "Gallery", "JGPRogressHUD", "EmptyDataSet" and "NVActivityIndicatorView" in order to present a friendlier interface.
  
  ## User Access Management
  Using Firebase's authentication handler, the registration is programmed to check if the email and the password the user provides are compliant with Firebase's regulations and the user is presented with instances of JGProgressHUD. 
  
  ## Custom cells
  Each item inside a TableViewController is custom, containing a photo, the title, price and description.
  ![Simulator Screen Shot - iPhone 11 Pro Max - 2020-07-01 at 14 57 44](https://user-images.githubusercontent.com/55602310/86241315-623a2180-bbab-11ea-81f4-7dcdafe0fe02.png)
  
  ## Search view
  The search view is animated, as when the user clicks the search icon, the text field and the button presents themselves to the user. Also, on clicking the search button, the keyboard dismisses itself.
  
  ## Basket view
  The basket view presents the user the items that were added to cart and each cell that contains the item. The basket view also presents a summary containing the number of total items and total price. The checkout button, for now, empties the basket and adds all the selected items to the purchase history.
  ![Simulator Screen Shot - iPhone 11 Pro Max - 2020-07-01 at 14 58 11](https://user-images.githubusercontent.com/55602310/86241367-741bc480-bbab-11ea-98d2-4dfa5f9d80c2.png =250x250)

  
  ## Profile view
  The profile view presents different options, according to the status of the user: 
    if the user is not logged in, the state will be presented and the login button will be shown on the top right corner;
    if the user is logged in and the registration is not complete, as the user did not enter its credentials and his address, the state will be presented as 'Finish registration';  
      ![Simulator Screen Shot - iPhone 11 Pro Max - 2020-07-01 at 14 58 38](https://user-images.githubusercontent.com/55602310/86241427-885fc180-bbab-11ea-9e3f-597bfd343d06.png =250x250) 
    if the user is logged in and the registration is complete, the state will be presented as 'Registration complete';
  
