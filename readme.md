## 笔记
1. project-skeleton-server 在`application.yml`增加了中文注释，运行后，结果如下：
```
java.lang.IllegalStateException: Failed to load property source from location 'classpath:/application.yml'
    Caused by: java.nio.charset.MalformedInputException: Input length = 1
```
原因：使用了GBK输入中文注释，另外`maven-resource-plugin`复制资源文件得时候配置使用UTF-8,编码不匹配，所以在classes目录下的
`application.yml`中文注释部分成了乱码，故有次报错。将文件保存UTF-8编码即可解决。

2. 在使用`@GrpcClient("hello-server")` 注解的时候，发现无论如何都找不到服务端的连接。难受2-3个小时，直到我发现了这个。。。
```
@SpringBootApplication
public class Client {

	public static void main(String[] args) {
		SpringApplication.run(Client.class, args);
		System.out.println(new HelloClient().receiveGreeting(args[0]));
	}

}

```
知道原因后，条件反射的修改成。。。。
```
public static void main(String[] args) {
    ConfigurableApplicationContext context = SpringApplication.run(Client.class, args);
    HelloClient bean = context.getBean(HelloClient.class);
    System.out.println(bean.receiveGreeting(args[0]));
}
```
最后连上了。。。哈哈，其实原因很简单，在使用`@GrpcClient("hello-server")` 注解的那个字段已经成功的把连接建立起来了，但是由于
它是Spring Context Bean的那个实例中的属性，然而我在上面代码中又新实例化一个对象，自然就没有帮我继续建立这个连接，所以就无法连接
到Grpc服务。也就是说，帮我建立好的连接的那个实例对象，我没去用，我自己反而去新创建一个对象，而且什么属性都没有初始化。

3. gitignore 存在意义可以避免前端人员在本地运行后台项目时，误提交无用的文件

4. 关于RootLogger级别的问题。如果RootLogger的级别设置为DEBUG，那么会输出应用系统和引入的Jar中debug日志请求。如果只想在自己
的应用程序中打印debug,那么需要设置 `RootLogger Level=INFO`，并在所需要debug日志请求的类中引入如下：
```
private final static Logger debugLogger = LoggerFactory.getLogger("DebugLogger");
```
> 该日志记录器的具体配置，请查看 `logback-spring.xml` 中`name = 'DebugLogger'`的Logger 。
## 参考文章
- [日志框架 Logback 官方手册（第二章：架构）](https://www.jianshu.com/p/b000126a0cda)
- [logback 最佳实践](https://www.jianshu.com/p/d648493667c0)
