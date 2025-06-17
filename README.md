# gorae project kafka directory convention

# 🔥 필요성

프론트엔드와 백엔드의 엔드포인트를 연결하듯 kafka에 있어서는\
producing, consuming 하는 메세지를 적절히 파싱해야 합니다.

이에 서로 다른 서비스를 개발하는 입장에서\
다른 서비스에서 프로듀싱 하는 데이터의 형태를 맞춰주어야 메세지소비가 가능해집니다.

이에 `kafka`에 대한 획일화된 디렉토리를 통해\
다른 서비스 개발자의 dto 를 명확하게 확인하고 개발의 편의성을 높히고자 합니다.

<br>

# 🔥 프로젝트 구성
```markdown
com.gorae-user-service
└── kafka                     
    ├── consumer
    │   ├── KafkaMessageConsumer.java   
    │   ├── alim             
    │   │   ├── dto          
    │   │   └── service      
    │   └── post             
    │       ├── dto
    │       └── service
    └── producer       
        ├── KafkaMessageProducer.java   
        ├── alim
        │   └── dto
        └── post
            └── dto
```

<br>

# 🔥 디렉토리 구성 방식

```
현재 프로젝트가 `user` 서비스이고
`post`,`alim` 서비스로 발행하는 메세지, 소비되는 메세지가 존재한다고 가정하겠습니다.
```

## 💠 `consumer` 그리고 `producer`
`kafka` 최상단 디렉토리 바로 아래의 두 디렉토리 입니다.\
아마 모든 서비스가 적어도 하나의 프로듀서, 컨슈머를 구현해야할 것입니다.\
이를 구분짓기 위해 기본적으로 각각의 디렉토리를 생성합니다.\
`consumer` 디렉토리, `producer` 디렉토리 순서대로 설명을 작성해두겠습니다.

<br>

## 💠 `consumer`
### `consumer.alim or post.dto`
메세지를 소비하는 주체가 `user`가 된 경우입니다.\
이 경우 `post` , `alim` 서비스에서 발행되는 메세지를 구독하고 있는 상황에서\
각각의 메세지를 소비하기 위해 `dto` 디렉토리를 작성합니다.


### `consumer.alim or post.service`
`producer`와 다르게 `service` 디렉토리가 존재합니다.\
다른 서비스로부터 메세지가 발행되고, 해당 메세지를 소비하여 처리하는\
`user` 서비스만의 서비스로직을 작성해두는 코드입니다.\
`producing`하는 서비스를 개발하는 개발자가 함께 확인하기 용의하도록 따로 작성합니다.

<br>

## 💠 `producer`
### `producer.alim or post.dto`
메세지를 발행하는 주체가 `user`가 된 경우입니다.\
이 경우 `post`, `alim` 서비스가 구독하고 있는 토픽에 발행하는 메세지의 `dto`를 작성합니다.\


### `producer` service 는 왜 없나요?
`producer` 로서의 `user` 서비스는 본인의 메인 로직을 처리하고\
메세지 발행하는 행위에서 추가적인 서비스 로직을 수행하지 않습니다.\
이에 따로 kafka 메세지 발행을 위한 service 는 필요로 하지 않습니다.\
(cf) 늘 했던것 처럼 kafka 와 같은 레벨로서 controller, service 디렉토리에 구성해주시면 됩니다.

<br>

## 💠 DTO Class name
`DTO` 클래스의 이름은\
`TOPIC + EVENT`로 통일합니다.\
예를들어 `TOPIC` 명이 `user-info`라면 아래와 같이 클래스를 작성합니다.
```java
public class UserInfoEvent {
    
}
```

<br>

# 🔥 yaml 파일 프로퍼티

추가적으로 수업시간에 진행한 부분으로 프로퍼티를 구성했습니다.\
필요에 따라 적절하게 쓰시면 될것 같습니다.\
가장 중요한 부분은 `headers`를 꼭 false로 주어야 합니다.(메세지 소비하는 과정이 복잡해집니다.)
```yaml
kafka:
  listener:
    ack-mode: manual_immediate

  consumer:
    group-id: ${spring.application.name}
    key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
    value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
    enable-auto-commit: false
    auto-offset-reset: latest
    max-poll-records: 10
    properties:
      spring.json.trusted.packages: "*"
      spring.json.use.type.headers: false

  producer:
    key-serializer: org.apache.kafka.common.serialization.StringSerializer
    value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
    properties:
      spring.json.add.type.headers: false
```

