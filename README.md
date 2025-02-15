# Double Partner V - Test

This project is for a Double Partner V Company test.

## Proposed architecture

lib/
├── core/
│   ├── errors/
│   ├── injection/
│   └── usecases/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── infrastructure/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
├── blocs/
├── pages/
└── widgets/


This project connects to a firebase authentication and firestore for managing users and addresses.
The project incorporates a hexagonal architecture, separating the domain from the infrastructure in 
such a way that it becomes scalable. For example, an authentication method other than firebase could 
be used without any problem, being added in the infrastructure (adapters) and consumed in the domain 
(ports).

This project is a starting point for a Flutter application.

## Requirements:

- Flutter version 3.24.3
- Ruby version 3.4.1

## Run App:

1. Clone the project
2. Navigate to the project and install the pubs with the command ´´´flutter pub get´´´ 
3. Navigate to ios folder and run the command ´´´pod install´´´
4. In the project index, run ´´´flutter run´´´
5. Enjoy the project.

![Home](https://i.postimg.cc/CMXKPfPy/temp-Image2-Hck-Go.avif)
![Home](https://i.postimg.cc/br7NsKDY/temp-Imagec-C57-BP.avif)
![Home](https://i.postimg.cc/XJDv0ZnC/temp-Imagep9-N89a.avif)
![Home](https://i.postimg.cc/J0Dz71hd/temp-Image-UIgze7.avif)
![Home](https://i.postimg.cc/4d33MvRG/temp-Image-Zd-Muke.avif)