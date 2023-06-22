#  Memories
Сохраняйте свои воспоминания и делитесь ими с другими пользователями.  

&nbsp;  
## Аккаунт для тестирования
Для тестирования приложения Вы можете воспользоваться уже существующим аккаунтом, на котором есть 4 публикации

Логин: tester@account.ru  
Пароль: Password1  
  
&nbsp;
&nbsp;  
В разделе "поиск" Вы также можете изучить публикации пользователей с именами **Anakin** и **IronMan** или других пользователей, которых Вы создадите.
- Note: Логин в поле поиска необходимо вводить целиком.  

&nbsp;
&nbsp;
## Описание
Приложение позволяет сохранять свои воспоминания (фотографии, заголовки и даты) и смотреть публикации других людей.

Первый экран предоставляет пользователю возможность зарегистрироваться или войти в приложение с имеющимся аккаунтом.
Регистрация и вход реализованы с помощью сервиса **Firebase Authentication**.  
![First screen. User can Log In or Sign Up.][image-1]
  

  
Основной экран (Memories) приложения содержит все публикации, которые сделал пользователь. На устройстве данные по каждому посту хранятся в CoreData. Также публикации пользователя синхронизируются с **Firebase Realtime Database** (заголовок и дата публикации) и **Firebase Storage** (хранение фотографий).  
![Main screen. Users can browse their posts and add new][image-2]

На основном экране имеется возможность создания новой публикации при нажатии на голубую кнопку со значком **+**. В открывшемся окне пользователь может добавить до 10 фотографий, задать название публикации и выбрать дату события.  
![Add memory screen. Users can add up to 10 photos, post title and date of event][image-3]


При нажатии на публикации пользователь может просматривать их.  
![Browse memory screen. Users can browse post][image-4]

&nbsp;
На экране поиска пользователь может искать другие аккаунты и просматривать их публикации.  
- Note: Логин в поле поиска необходимо вводить целиком.

&nbsp;
![Search screen. Users can search other accounts][image-5]  
  

  
&nbsp;
Экран отображения публикаций других пользователей выглядит иначе, но также предоставляет возможность просматривать публикации.  
![Other user's memories screen. Users can browse other account's memories][image-6]

На экране профиля пользователя можно изменить фото аккаунта и совершить выход из аккаунта.  
![Profile screen. Users can change their main photo and log out][image-7]



[image-1]:    Screenshots/FirstScreen.PNG
[image-2]:    Screenshots/MainScreen.PNG
[image-3]:    Screenshots/AddMemory.PNG
[image-4]:    Screenshots/BrowseMemory.PNG
[image-5]:    Screenshots/SearchScreen.PNG
[image-6]:    Screenshots/OtherUser'sMemories.PNG
[image-7]:    Screenshots/ProfileScreen.PNG
