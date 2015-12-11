
x = 0:1:5;

figure;
subplot(2,3,1)
set(gca,'yscale','log')
hold on
for i=1:an
    semilogy(x,applefeatures(i,:),'b-'), title('applefeatures')
end
hold off
subplot(2,3,2)
set(gca,'yscale','log')
hold on
for i=1:ban
    semilogy(x,bananafeatures(i,:),'r-'), title('bananafeatures')

end
hold off
subplot(2,3,3)
set(gca,'yscale','log')
hold on
for i=1:bon
    semilogy(x,bowlfeatures(i,:),'g-'),title('bowlfeatures')

end
hold off
subplot(2,3,4)
set(gca,'yscale','log')
hold on
for i=1:mn
    semilogy(x,mushroomfeatures(i,:),'c-'),title('mushroomfeatures')
end
hold off
subplot(2,3,5)
set(gca,'yscale','log')
hold on
for i=1:kn
    semilogy(x,keyboardfeatures(i,:),'m-'),title('keyboardfeatures')
end
hold off