package com.study.springboot.oauth;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.study.springboot.oauth2.CustomOAuth2UserService;


@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter
{
	
	@Autowired
	public AuthenticationFailureHandler authenticationFailureHandler;
	@Autowired
	private CustomOAuth2UserService customOAuth2UserService;

	@Override
	protected void configure(HttpSecurity http) throws Exception
	{
		http.authorizeRequests()
				.antMatchers("/", "/main/**").permitAll()
				.antMatchers("/send-one").permitAll()
				.antMatchers("/css/**", "/js/**", "/upload/**").permitAll()
				.antMatchers("/order/optionListener").permitAll()
				.antMatchers("/login/**", "/flutter/**", "/restaurant/**").permitAll()
				.antMatchers("/j_spring_security_check").permitAll()
//				.antMatchers("/timeline/**").hasAnyRole("USER", "ADMIN")
//				.antMatchers("/manage/**").hasRole("ADMIN")
				.anyRequest().authenticated();
		
		http.formLogin()
			.loginPage("/login/login")
			.loginProcessingUrl("/j_spring_security_check")			
			.successForwardUrl("/login/loginOk")
			.failureHandler(authenticationFailureHandler)
			.usernameParameter("email")
			.passwordParameter("pw")
			.permitAll();
			
		http.logout()
			.logoutUrl("/logout")
			.logoutSuccessUrl("/")
			.permitAll();
		
		// SSL을 사용하지 않으면 True로 사용
		http.csrf().disable()
		.headers().frameOptions().disable()
		.and()
		.oauth2Login().userInfoEndpoint().userService(customOAuth2UserService)
		.and()
		.defaultSuccessUrl("/login/socialInfoCheck");
	}
	
	
	@Autowired
	private DataSource dataSource;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception
	{
		auth.jdbcAuthentication()
			.dataSource(dataSource)
			.usersByUsernameQuery("select email as userName, pw as password, enabled from member where email = ? and type = 'normal'")
			.authoritiesByUsernameQuery("select email as userName, authority from member where email = ? and type = 'normal'")
			.passwordEncoder(passwordEncoder());
	}
	
	// passwordEncoder 추가
	public PasswordEncoder passwordEncoder()
	{
		return PasswordEncoderFactories.createDelegatingPasswordEncoder();
	}
}
