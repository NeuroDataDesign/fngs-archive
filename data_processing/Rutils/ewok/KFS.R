KFS <- function(A,C,Q,R,x0,v0,y) {

  T=dim(y)[2]
  d=dim(A)[1]
  Fv1=array(0, dim=c(d,d,T))
  Fv2=array(0, dim=c(d,d,T))
  Fx1=array(0, dim=c(d,T))
  Fx2=array(0, dim=c(d,T))
  Sx=array(0, dim=c(d,T))
  Sv=array(0, dim=c(d,d,T))
  Scov=array(0, dim=c(d,d,T))
  
  CRC = t(C) %*% solve(R) %*% C
  
  # Filter
  for (t in 1:T) {
    if (t==1) {
      Fv1[,,t]=v0-(v0%*%CRC%*%v0-v0%*%CRC%*%solve(solve(v0)+CRC)%*%CRC%*%v0)
      Fv2[,,t]=A%*%Fv1[,,t]%*%t(A)+Q
      Fx1[,t]=t(x0)+v0%*%t(C)%*%solve(R)%*%(y[,t]-C%*%t(x0))-v0%*%CRC%*%solve(solve(v0)+CRC)%*%t(C)%*%solve(R)%*%(y[,t]-C%*%t(x0))
      Fx2[,t]=A%*%Fx1[,t]
    } else {
      v2=Fv2[,,t-1]
      Fv1[,,t]=v2-v2%*%CRC%*%v2+v2%*%CRC%*%solve(solve(v2)+CRC)%*%CRC%*%v2
      Fv2[,,t]=A%*%Fv1[,,t]%*%t(A)+Q
      x2=Fx2[,t-1]
      Fx1[,t]=x2 + v2%*%t(C)%*%solve(R)%*%(y[,t]-C%*%x2)-v2%*%CRC%*%solve(solve(v2)+CRC)%*%t(C)%*%solve(R)%*%(y[,t]-C%*%x2)
      Fx2[,t]=A%*%Fx1[,t]
    }
  }
  
  # Smoother
  for (i in 1:T) {
    t=T-i+1
    if (t==T) {
      Sv[,,t]=Fv1[,,t]
      Jt=Fv1[,,t]%*%t(A)/(Fv2[,,t])
      Jt[is.na(Jt)] <- 0
      Scov[,,t]=Fv2[,,t]%*%t(Jt)
      Sx[,t]=Fx1[,t]+Jt%*%(Fx2[,t]-A%*%Fx1[,t])
    } else {
      Jt=Fv1[,,t]%*%t(A)/(Fv2[,,t])
      Jt[is.na(Jt)] <- 0
      Sv[,,t]=Fv1[,,t]+Jt%*%(Sv[,,t+1]-Fv2[,,t])%*%t(Jt)
      Scov[,,t]=Sv[,,t+1]%*%t(Jt)
      Sx[,t]=Fx1[,t]+Jt%*%(Sx[,t+1]-A%*%Fx1[,t])
    }
  }
  return(list(Fv1=Fv1,Fv2=Fv2,Fx1=Fx1,Fx2=Fx2,Sx=Sx,Sv=Sv,Scov=Scov))
}
  