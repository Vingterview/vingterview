package ving.vingterview.annotation;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import ving.vingterview.dto.auth.SessionMember;

@Slf4j
@RequiredArgsConstructor
@Component
public class LoginMemberArgumentResolver implements HandlerMethodArgumentResolver {
    private final HttpSession session;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        boolean isLoginMemberAnnotation = parameter.getParameterAnnotation(LoginMember.class) != null;
        boolean isSessionMemberClass = SessionMember.class.equals(parameter.getParameterType());

        return isLoginMemberAnnotation && isSessionMemberClass;
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        log.info("============================ArgumentResolver============================");
        log.info("sessionId: {}", session.getId());
        session.getAttributeNames().asIterator().forEachRemaining(element -> {
            log.info("attributeNames: {}", element);
        });
        log.info("SPRING_SECURITY_CONTEXT: {}", session.getAttribute("SPRING_SECURITY_CONTEXT"));
        log.info("============================ArgumentResolver============================");

        return session.getAttribute("member");
    }
}
