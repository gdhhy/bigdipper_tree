package com.zcreate;


import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.File;

/**
 * 配置到应用服务器启动时自动加载，环境变量和配置文件初始化<p>
 *
 * @author 黄海晏
 * Date: 2009-11-19
 * Time: 22:19:41
 */
public class AppStartListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent event) {
        String deploy_dir = event.getServletContext().getRealPath(File.separator);
        if (!deploy_dir.endsWith(File.separator))
            deploy_dir += File.separator;
        DeployRunning.setDir(deploy_dir);
        //  Config.setAppPathRoot(class_root);

        String log_dir = deploy_dir + "WEB-INF" + File.separator + "logs";
        File file = new File(log_dir);// String 中文版;
        if (!file.isDirectory())
            file.mkdirs();
        else
            //System.out.println("日志目录已存在");
            System.out.println("log4j日志目录 = " + log_dir);
        System.setProperty("LOG_DIR", log_dir);

    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
    }
}
