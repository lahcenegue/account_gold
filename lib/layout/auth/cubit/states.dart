abstract class AuthStates {}

class InitialState extends AuthStates{}

class ChangePasswordVisibilityState extends AuthStates{}

class LoginLoading extends AuthStates{}
class LoginSuccess extends AuthStates{}
class LoginError extends AuthStates{}


class NewUrlSuccess extends AuthStates{}